//
//  FakeStepConfigs.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

/**
 * The data for the configurations which show up as badges in the UI,
 * i.e. the 5 features (GUI frameworks) we test.
 *
 * Note that there are also `FakeStep`s, which also contain the info
 * whether or not the feature is available or not.
 */
struct FakeStepConfig : Equatable, Identifiable {
  
  let id                : Int
  let runTitle          : String
  let positiveTitle     : String
  let positiveCheckmark : String
  let negativeTitle     : String
  let negativeCheckmark : String
  
  static let electron = FakeStepConfig(
    id                : 1,
    runTitle          : "Checking for Electron …",
    positiveTitle     : "App is ⚛️ Electronized! The Web is going to take over!",
    positiveCheckmark : "🙈",
    negativeTitle     : "No ⚛️ Electrons detected, GPU & RAM are secure.",
    negativeCheckmark : "✅"
  )
  static let catalyst = FakeStepConfig(
    id                : 2,
    runTitle          : "Catalyzed? …",
    positiveTitle     : "Uses macOS 🧪 Catalyst, don't resize windows!",
    positiveCheckmark : "🙉",
    negativeTitle     : "No 🧪 Catalysts detected. Fast windows resizing.",
    negativeCheckmark : "✅"
  )
  static let swiftUI = FakeStepConfig(
    id                : 3,
    runTitle          : "Maybe declarative? …",
    positiveTitle     : "App is using SwiftUI, that can be ❡ declared.",
    positiveCheckmark : "🙊",
    negativeTitle     : "Nothing seems to be “declared” ❡ No SwiftUI in use.",
    negativeCheckmark : "❌"
  )
  static let phone = FakeStepConfig(
    id                : 4,
    runTitle          : "Possibly an iPhone application? …",
    positiveTitle     : "This looks like an 📱 iPhone or iPad app!",
    positiveCheckmark : "📱",
    negativeTitle     : "Not an 📱 iPhone app. Those don't belong here.",
    negativeCheckmark : "✅"
  )
  static let appKit = FakeStepConfig(
    id                : 5,
    runTitle          : "Checking for old-school AppKit …",
    positiveTitle     : "What to expect, indeed this app uses 🖥 AppKit!",
    positiveCheckmark : "👨🏽‍🦳",
    negativeTitle     : "No 👨🏽‍🦳 AppKit usage to be found? 🤔",
    negativeCheckmark : "❌"
  )

  static let all : [ FakeStepConfig ] = [
    .electron, .catalyst, .swiftUI, .phone, .appKit
  ]
}
