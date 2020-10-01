//
//  FakeDetectionStepper.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import Combine
import AppKit

/**
 * This is the result of a technology analysis.
 */
struct FakeStep: Identifiable {
  var id     : Int { config.id }
  let config : FakeStepConfig
  var state  : Bool
}

/**
 * A "ViewModel" object which steps through a set of FakeStep's,
 * aka features we detect (well, detected already, this is just
 * a fake progress emulator).
 */
final class FakeDetectionStepper: ObservableObject {
  
  /**
   * Wrap a fake step one more time - this is necessary to fake the
   * "processing" phase.
   */
  struct ActiveStep: Identifiable {
    // This one is faking the 'pending' state
    
    var id      : Int            { step.id     }
    var config  : FakeStepConfig { step.config }
    
    let step    : FakeStep
    var pending : Bool
    
    var state   : Bool? { pending ? nil : step.state }
    
    // Doesn't really belong here, but well:
    
    var title : String {
      switch state {
        case .none: return config.runTitle
        case .some(true)  : return config.positiveTitle
        case .some(false) : return config.negativeTitle
      }
    }
    var checkmark: String  {
      switch state {
        case .none: return ""
        case .some(true)  : return config.positiveCheckmark
        case .some(false) : return config.negativeCheckmark
      }
    }
  }
  
  /// Seconds, we take a random value in this range to determine the fake
  /// progress delay.
  let stepRange = 0.3...1.2
  
  private var nextDelay: DispatchTimeInterval {
    return .milliseconds(Int(TimeInterval.random(in: stepRange) * 1000.0))
  }
    
  private var allSteps = [ FakeStep ]()
  
  @Published var activeSteps = [ ActiveStep ]()
  
  var isDone : Bool {
    if activeSteps.count < allSteps.count { return false }
    if activeSteps.count > allSteps.count { return true }
    return !(activeSteps.last?.pending ?? false)
  }
  
  deinit {
    stop()
  }
  func stop() {
  }
  func suspend() {
    stop()
    activeSteps = []
    allSteps = []
  }
  
  func resume(with steps: [ FakeStep ]) {
    allSteps = steps
    activeSteps = []

    self.NeXTstep()

    DispatchQueue.main.asyncAfter(deadline: .now() + nextDelay) {
      self.NeXTstep()
    }
  }
  
  private func scheduleOpenStep() {
    guard !isDone else { stop(); return }
    DispatchQueue.main.asyncAfter(deadline: .now() + nextDelay) {
      self.NeXTstep()
    }
  }
  
  private func NeXTstep() {
    defer { scheduleOpenStep() }
    
    if activeSteps.last?.pending ?? false {
      activeSteps[activeSteps.count - 1].pending = false
      return
    }
    
    guard activeSteps.count < allSteps.count else { return stop() }
    activeSteps.append(.init(step: allSteps[activeSteps.count], pending: true))
  }
}
