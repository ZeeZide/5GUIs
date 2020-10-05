//
//  WindowState.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

final class WindowState: ObservableObject {
  
  enum State : Equatable {
    case empty
    case loading(URL)
    case notAnApp(URL)
    case app(ExecutableFileTechnologyInfo)
  }
  
  @Published var state          = State.empty
  @Published var detectionState : BundleFeatureDetectionOperation?
  var fakeDetectionStepper = FakeDetectionStepper()
  
  var url : URL? {
    switch state {
      case .empty: return nil
      case .notAnApp(let url), .loading(let url): return url
      case .app(let info): return info.fileURL
    }
  }
  
  func loadURL(_ url: URL) {
    // Hm, we need a 'didChange' event, hence the delegate. (the observed
    // object emits a 'willChange')
    self.detectionState?.delegate = nil
    self.detectionState = nil
    fakeDetectionStepper.suspend()
    
    self.state = .loading(url)
    let detectionState = BundleFeatureDetectionOperation(url)
    self.detectionState = detectionState
    
    detectionState.delegate = self
    detectionState.resume()
  }
}

extension WindowState: BundleFeatureDetectionOperationDelegate {
  
  func detectionStateDidChange(_ state: BundleFeatureDetectionOperation) {
    guard detectionState === state else { return }
    
    switch state.state {
      case .failedToOpen:
        self.state = .empty
        self.detectionState = nil
        
      case .processing:
        self.state = .loading(state.url)
      
      case .finished:
        self.state = .app(state.info)
        fakeDetectionStepper.resume(with: state.info.analysisResults)
        
        #if false // until done
        self.detectionState = nil
        #endif
        // TODO: analysis
        
      case .notAnApplication:
        self.state = .notAnApp(state.url)
        self.detectionState = nil
        
    }
  }
}
