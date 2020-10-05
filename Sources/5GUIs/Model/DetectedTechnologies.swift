//
//  DetectedTechnologies.swift
//  5GUIs
//
//  Created by Helge Heß on 05.10.20.
//

struct DetectedTechnologies: OptionSet {
  let rawValue : UInt64

  // 1st party technologies
  static let carbon      = DetectedTechnologies(rawValue: 1 << 1)
  static let appkit      = DetectedTechnologies(rawValue: 1 << 2)
  static let automator   = DetectedTechnologies(rawValue: 1 << 3) // as a lang?
  static let webkit      = DetectedTechnologies(rawValue: 1 << 4)
  static let uikit       = DetectedTechnologies(rawValue: 1 << 5)
  static let swiftui     = DetectedTechnologies(rawValue: 1 << 6)
  
  // 3rd party technologies
  static let electron    = DetectedTechnologies(rawValue: 1 << 10)
  static let catalyst    = DetectedTechnologies(rawValue: 1 << 11)
  static let qt          = DetectedTechnologies(rawValue: 1 << 12)
  static let wxWidgets   = DetectedTechnologies(rawValue: 1 << 13)
  static let platypus    = DetectedTechnologies(rawValue: 1 << 14)

  // Detected languages
  static let objc        = DetectedTechnologies(rawValue: 1 << 20)
  static let swift       = DetectedTechnologies(rawValue: 1 << 21)
  static let cplusplus   = DetectedTechnologies(rawValue: 1 << 22)
  static let python      = DetectedTechnologies(rawValue: 1 << 23)
  static let java        = DetectedTechnologies(rawValue: 1 << 24)
  static let applescript = DetectedTechnologies(rawValue: 1 << 25)
}
