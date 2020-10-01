//
//  ContentView.swift
//  5 GUIs
//
//  Created by Helge Heß on 28.09.20.
//

import SwiftUI

struct ContentView: View {
  
  @Environment(\.window) private var window
  
  @State          private var isTargeted = false
  @ObservedObject private var stateObserver : WindowState
  private var state = WindowState() // to keep it around? cycle or not?
  
  init() {
    stateObserver = state
  }

  private var url : URL? { state.url }

  func loadURL(_ url: URL) {
    window?.title = url.lastPathComponent
    state.loadURL(url)
  }
  
  private func openInNewWindow(_ url: URL) {
    let view   = ContentView()
    let window = makeAppWindow(view)
    window.makeKeyAndOrderFront(nil)
    view.loadURL(url)
  }

  private func loadURLs(_ urls: [ URL ]) {
    urls.first.flatMap(loadURL)
    urls.dropFirst().forEach { openInNewWindow($0) }
  }

  private func handleDrop(items: [ NSItemProvider ]) -> Bool {
    guard !items.isEmpty else { return false }

    items.first.flatMap { $0.loadURL { $0.flatMap(self.loadURL) } }
    
    items.dropFirst().forEach { // item load is async!
      $0.loadURL { $0.flatMap { openInNewWindow($0) } }
    }
    
    return true
  }
  
  private func onOpen() {
    let panel = makeOpenPanel()
    if let window = window {
      panel.beginSheetModal(for: window) { response in
        if response == .OK { self.loadURLs(panel.urls) }
      }
    }
    else {
      panel.begin { response in
        if response == .OK { self.loadURLs(panel.urls) }
      }
    }
  }
  
  private var activeGradient : LinearGradient {
    isTargeted ? style.hoverFillGradient : style.baseFillGradient
  }

  var body: some View {
    Group {
      // TBD: can we transition between the views nicely?
      if isTargeted {
        PleaseDropAFileView()
      }
      else if case .notAnApp(let url) = state.state {
        SorryNotAnExecutableView(url: url)
      }
      else if let detectionState = state.detectionState {
        MainFileView(stepper: state.fakeDetectionStepper, state: detectionState)
      }
      else {
        PleaseDropAFileView()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    .foregroundColor(style.textColor)
    .background(activeGradient)
    .animation(.default)
    
    .onDrop(of: [ UTI.fileURL.rawValue ], isTargeted: $isTargeted,
            perform: handleDrop)
    
    .edgesIgnoringSafeArea(.all)
    
    .focusable() // doesn't help w/ onCommand either?
   
    // we never get this?
    .onCommand(#selector(ResponderActions.openDocument(_:)), perform: onOpen)
  }
}

@objc protocol ResponderActions {
  func openDocument(_ sender: Any?)
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
