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
  
  var embeddedExecutables  = [ ExecutableFileTechnologyInfo ]()
  
  var detectedTechnologies : DetectedTechnologies = []
}

extension ExecutableFileTechnologyInfo {
  // View layer stuff, doesn't really belong here

  var appName : String {
    infoDictionary?.displayName
      ?? infoDictionary?.name
      ?? executableURL?.lastPathComponent
      ?? "???"
  }
  
  var embeddedTechnologies : DetectedTechnologies {
    var techs = DetectedTechnologies()
    for info in embeddedExecutables {
      techs.formUnion(info.detectedTechnologies)
    }
    return techs
  }
}
