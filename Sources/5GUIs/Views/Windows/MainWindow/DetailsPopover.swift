//
//  DetailsPopover.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct DetailsPopover: View {
  
  let info : ExecutableFileTechnologyInfo
  
  private struct BundleInfoView: View {
    
    let info : InfoDict
    
    private var title : String {
      info.displayName ?? info.name ?? info.id ?? "??"
    }

    var body: some View {
      VStack {
        Text(verbatim: "Bundle: \(title)")
          .font(.callout)
          .padding()

        VStack(alignment: .leading, spacing: 4) {
          PropertiesView(properties: [
            ( "Bundle ID", info.id ),
            ( "Name", info.name ),
            ( "Info", info.info ),
            ( "Version", info.version ),
            ( "Short Version", info.shortVersion ),
            ( "Application Category", info.applicationCategory ),
          ])
          if info.appleScriptEnabled {
            Text("Fancy, AppleScript is enabled!")
          }
        }
      }
      .foregroundColor(Color(NSColor.textColor))
    }
  }
  
  private struct DependenciesView: View {
    
    let dependencies : [ String ]
    
    var body: some View {
      Group {
        if dependencies.isEmpty {
          Text("No dependencies detected, yet?")
        }
        else {
          VStack {
            Text("#\(dependencies.count) Dependencies:")
              .font(.callout)
              .padding()
            
            VStack(alignment: .leading, spacing: 2) {
              ForEach(dependencies, id: \.self) { dependency in
                Text(verbatim: dependency)
              }
            }
          }
        }
      }
    }
  }
  
  private var hasReceipt : Bool {
    guard let url = info.receiptURL else { return false }
    return FileManager.default.fileExists(atPath: url.path)
  }
  
  var body: some View {
    VStack {
      VStack(spacing: 8) {
        if let info = info.infoDictionary {
          BundleInfoView(info: info)
        }
        else {
          Text("No Bundle Info?")
        }
        if let url = info.executableURL {
          PropertyLine(name: "Executable", value: url.path)
        }
        
        if hasReceipt {
          Text("App has a receipt, probably downloaded from the AppStore!")
        }
      }
      .padding()
      
      Divider()
      
      DependenciesView(dependencies: info.dependencies)
        .padding()
    }
  }
}

struct DetailsPopover_Previews: PreviewProvider {
  static var previews: some View {
    DetailsPopover(info:
      ExecutableFileTechnologyInfo(
        fileURL: URL(fileURLWithPath: "/Applications/Xcode.app"),
        infoDictionary: InfoDict([
          "CFBundleIdentifier" : "blub.blab.blum",
          "CFBundleName"       : "VisualStudio"
        ]),
        executableURL: URL(fileURLWithPath:
                       "/Applications/Xcode.app/Contents/MacOS/VisualStudio"),
        receiptURL: nil,
        appImage: nil,
        dependencies: [
          "@rpath/DVTCocoaAdditionsKit.framework/Versions/A/DVTCocoaAdditionsKit",
          "/usr/lib/libobjc.A.dylib",
          "/usr/lib/swift/libswiftUniformTypeIdentifiers.dylib",
          "/usr/lib/swift/libswiftXPC.dylib"
        ],
        embeddedExecutables: [],
        detectedTechnologies: [ .appkit, .swift ]
      )
    )
  }
}
