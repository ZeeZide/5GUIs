//
//  ExecutableFileTechnologyInfo.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL
import struct SwiftUI.Image

struct ExecutableFileTechnologyInfo: Equatable {
  
  let fileURL        : URL
  
  var infoDictionary : InfoDict?
  var executableURL  : URL?
  var receiptURL     : URL?
  var appImage       : Image?
  var dependencies   = [ String ]()
  
  // TODO: Also scan embedded apps and plugins and keep them as a nested
  //       array in here.
  var embeddedExecutables = [ ExecutableFileTechnologyInfo ]()
  
  struct DetectedTechnologies: OptionSet {
    let rawValue : UInt64

    static let electron  = DetectedTechnologies(rawValue: 1 << 1)
    static let catalyst  = DetectedTechnologies(rawValue: 1 << 2)
    static let swiftui   = DetectedTechnologies(rawValue: 1 << 3)
    static let uikit     = DetectedTechnologies(rawValue: 1 << 4)
    static let appkit    = DetectedTechnologies(rawValue: 1 << 5)
    static let qt        = DetectedTechnologies(rawValue: 1 << 6)

    static let objc      = DetectedTechnologies(rawValue: 1 << 10)
    static let swift     = DetectedTechnologies(rawValue: 1 << 11)
    static let cplusplus = DetectedTechnologies(rawValue: 1 << 12)
    static let java      = DetectedTechnologies(rawValue: 1 << 14)
  }
  var detectedTechnologies : DetectedTechnologies = []
}

extension ExecutableFileTechnologyInfo.DetectedTechnologies {
  
  mutating func scanDependencies(_ dependencies: [ String ]) {
    for dep in dependencies {
      func check(_ option: ExecutableFileTechnologyInfo.DetectedTechnologies,
                 _ needle: String) -> Bool
      {
        guard !contains(option)    else { return false } // scanned already
        guard dep.contains(needle) else { return false }
        self.insert(option)
        return true
      }
      
      if check(.electron,  "Electron")          { continue }
      if check(.catalyst,  "UIKitMacHelper")    { continue }
      if check(.appkit,    "AppKit.framework")  { continue }
      if check(.swiftui,   "SwiftUI.framework") { continue }
      if check(.uikit,     "UIKit.framework")   { continue }
      if check(.qt,        "QtCore.framework")  { continue }
      
      if check(.cplusplus, "libc++")            { continue }
      if check(.objc,      "libobjc")           { continue }
      if check(.swift,     "libswiftCore")      { continue }
    }
  }
}

extension ExecutableFileTechnologyInfo {
  // View layer stuff, doesn't really belong here

  var appName : String {
    infoDictionary?.displayName
      ?? infoDictionary?.name
      ?? executableURL?.lastPathComponent
      ?? "???"
  }
}
