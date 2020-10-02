//
//  OTool.swift
//  5 GUIs
//
//  Created by Helge Heß on 28.09.20.
//

import Foundation

enum OToolError: Swift.Error {
  case xCodeMissing
  case objdumpMissing
  case invocationFailed(status: Int)
}

/**
 * A compiled LLVM objdump can be bundled in the app. Use a separate Copy build
 * phase with "Executables" as the target and make sure the binary is signed.
 */
fileprivate let embeddedObjdump : URL = {
  return Bundle.main.bundleURL
    .appendingPathComponent("Contents")
    .appendingPathComponent("MacOS")
    .appendingPathComponent("llvm-objdump")
}()

func otool(_ url: URL) throws -> [ String ] {
  // xcrun doesn't work in the Sandbox but calling Xcode's objdump DOES work,
  // on 10.15. On macOS Catalyst it doesn't.
  let fm = FileManager.default
  
  let objdump : String
  if fm.isExecutableFile(atPath: embeddedObjdump.path) {
    objdump = embeddedObjdump.path
  }
  else {
    let xCodePath = "/Applications/Xcode.app"
    objdump = "\(xCodePath)/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/objdump"
    // We don't require objdump, we can also derive info from the general
    // contents.
  }
  
  var dependencies = Set<String>()
  dependencies.reserveCapacity(32)
  try run(objdump: objdump, against: url, maxNesting: 3, into: &dependencies)
  return dependencies.sorted()
}

private func run(objdump: String, against url: URL,
                 nesting: Int = 1, maxNesting: Int = 4,
                 into result: inout Set<String>) throws
{
  guard nesting <= maxNesting else { return }
  
  let scannedDeps = result
  
  let directDeps = try run(objdump: objdump, against: url)
  result.formUnion(directDeps)
  guard nesting + 1 <= maxNesting else { return }
  
  let baseURL = url
    .deletingLastPathComponent() // Slack
    .deletingLastPathComponent() // MacOS
  
  for dep in directDeps {
    guard !scannedDeps.contains(dep) else { continue } // processed already
    
    let dependencyURL : URL
    
    func checkRelname<S: StringProtocol>(_ relname: S) -> URL? {
      let fw      = baseURL.appendingPathComponent("Frameworks")
      let fwDep   = fw.appendingPathComponent(String(relname))
      guard FileManager.default.fileExists(atPath: fwDep.path) else {
        print("did not find @ dep:",
              "\n  dep: ", dep,
              "\n  in:  ", url.path,
              "\n  base:", baseURL.path)
        return nil
      }
      return fwDep
    }
    
    // Hm, quite hacky :-)
    if dep.hasPrefix("@rpath/") {
      guard let url = checkRelname(dep.dropFirst(7)) else { continue }
      dependencyURL = url
    }
    else if dep.hasPrefix("@executable_path/../Frameworks/") {
      guard let url = checkRelname(dep.dropFirst(31)) else { continue }
      dependencyURL = url
    }
    else if dep.hasPrefix("@loader_path/../Frameworks/") {
      guard let url = checkRelname(dep.dropFirst(27)) else { continue }
      dependencyURL = url
    }
    else if dep.hasPrefix("@") {
      // e.g. @rpath/libswiftos.dylib
      print("unprocessed dependency @:", dep)
      continue
    }
    else {
      dependencyURL = URL(fileURLWithPath: dep, relativeTo: url)
    }
    
    do {
      try run(objdump: objdump, against: dependencyURL,
              nesting: nesting + 1, maxNesting: maxNesting,
              into: &result)
    }
    catch {
      print("ERROR: ignoring nested error:", error)
    }
  }
}

private func run(objdump: String, against url: URL) throws -> [ String ] {
  // bash escaping
  let result = Process.launch(at: objdump,
                              with: [ "-macho", "--dylibs-used", url.path ],
                              using: .none /* no shell */)
  guard result.status == 0 else {
    // status is 4 on signing errors (illegal instruction)
    // status is 127 for bash errors
    print("ERROR: objdump result:", result,
          "\n  path:", objdump,
          "\n  error:\n", result.stderr)
    throw OToolError.invocationFailed(status: result.status)
  }
  
  // Example:
  // /System/Library/PrivateFrameworks/Safari.framework/Versions/A/Safari (compatibility version 528.0.0, current version 610.1.28
  // We parse:
  // - deps must start with "\t" (we also accept " ")
  // - extra version info in () is cut off
  return result.stdout
    .split(separator: "\n", maxSplits: 1000, omittingEmptySubsequences: true)
    .lazy
    .filter { $0.hasPrefix(" ") || $0.hasPrefix("\t") }
    .map { ( s : Substring ) -> Substring in
      guard let idx = s.lastIndex(of: "(") else { return s }
      return s[..<idx]
    }
    .map    { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    .filter { !$0.isEmpty }
}
