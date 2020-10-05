//
//  InfoDict.swift
//  5 GUIs
//
//  Created by Helge Heß on 28.09.20.
//

struct InfoDict: Equatable {
  
  let id                   : String? // com.apple.Safari
  let name                 : String? // Safari
  let displayName          : String? // Safari
  let info                 : String?
  let version              : String?
  let shortVersion         : String? // 14.0
  let applicationCategory  : String?
  let supportedPlatforms   : [ String ] // MacOSX
  let minimumSystemVersion : String?
  let appleScriptEnabled   : Bool
  let JavaX                : Bool // e.g. JD-GUI
  
  let iconName   : String? // AppIcon
  let iconFile   : String? // AppIcon
  
  let executable : String? // Safari
  
  // TODO: services?
  // CFBundleURLTypes
  // CFBundleDocumentTypes
  
  init(_ dictionary: [ String : Any ]) {
    func S(_ key: String) -> String? {
      guard let s = dictionary[key] as? String else { return nil }
      return s.isEmpty ? nil : s
    }
    func B(_ key: String) -> Bool {
      guard let v = dictionary[key] else { return false }
      if let b = v as? Bool { return b }
      if let i = v as? Int { return i != 0 }
      if let s = (v as? String)?.lowercased() {
        if s == "no" || s == "false" { return false }
        return !s.isEmpty
      }
      return false
    }
    
    id                   = S("CFBundleIdentifier")
    name                 = S("CFBundleName")
    info                 = S("CFBundleGetInfoString")
    displayName          = S("CFBundleDisplayName")
    version              = S("CFBundleVersion")
    shortVersion         = S("CFBundleShortVersionString")
    minimumSystemVersion = S("LSMinimumSystemVersion")
    applicationCategory  = S("LSApplicationCategoryType")

    iconName             = S("CFBundleIconName")
    iconFile             = S("CFBundleIconFile")

    executable           = S("CFBundleExecutable")

    appleScriptEnabled   = B("NSAppleScriptEnabled")
    
    supportedPlatforms = dictionary["CFBundleSupportedPlatforms"] as? [ String ]
                      ?? []
    JavaX = dictionary["JavaX"] != nil
  }
}
