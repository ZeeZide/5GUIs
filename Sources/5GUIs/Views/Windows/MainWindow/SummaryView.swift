//
//  SummaryView.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

/**
 * After all detection badges are shown, we present a summary.
 */
struct SummaryView: View {
  
  let info : ExecutableFileTechnologyInfo
  
  var body: some View {
    HStack {
      Text(verbatim: info.summaryText)
        .padding(16)
    }
    .font(.callout)
    .foregroundColor(Color(NSColor.textColor))
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color(NSColor.textBackgroundColor))
    )
  }
}

fileprivate struct Texts {
  
  static let none     = "Crazy, we couldn't detect any technology?!"
  static let fallback = "We don't have any words for this combination!"
  
  static let electronAndCatalyst =
    "Uh boy, this app uses Electron AND Catalyst! What a strange combo."
  static let electronAndSwiftUI =
    "Uses Electron and SwiftUI. This app might be a proper native app soon!"
  static let electron =
    "An Electron app. Sure, why not!"

  static let catalyst =
    "A macOS Catalyst app, i.e. a mobile app " +
    "longing for larger screens w/o touch (yet?)."
  
  static let phone =
    "This seems to be an iPhone or iPad app. Welcome Apple silicon!"
  
  static let swiftui =
    "SwiftUI. Respect! " +
    "The developer of this app likes to live on the bleeding edge."
  
  static let appKitSwift =
    "An AppKit app. But a modern one! This app is using Swift."
  static let appKitObjC =
    "A gem! This app looks a trustworthy AppKit Objective-C app. " +
    "No experiments, please!"
  
  static let java =
    "Java. An actual app built using Java. Charles, is this you?"

  static let qt =
    "Qt. Anything can happen. Run."
}

fileprivate extension ExecutableFileTechnologyInfo {
  
  func features(_ feature: ExecutableFileTechnologyInfo.DetectedTechnologies)
       -> Bool
  {
    detectedTechnologies.contains(feature)
  }
  
  var summaryText : String {
    if detectedTechnologies.isEmpty { return Texts.none }
    
    if features(.electron) {
      if features(.catalyst) { return Texts.electronAndCatalyst }
      if features(.swift)    { return Texts.electronAndSwiftUI  }
      return Texts.electron
    }
    
    if features(.catalyst) {
      return Texts.catalyst
    }
    
    if !features(.catalyst) && features(.uikit) && !features(.appkit) {
      return Texts.phone
    }

    if features(.java) {
      return Texts.java
    }

    if features(.swiftui) {
      return Texts.swiftui
    }
    
    if features(.qt) {
        return Texts.qt
    }
    
    if features(.appkit) {
      if features(.swift) { return Texts.appKitSwift }
      return Texts.appKitObjC
    }
    
    return Texts.fallback
  }
}
