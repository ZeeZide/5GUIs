//
//  DetectionStepsView.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

/**
 * Showing a list of fake detection steps. Driven by the
 * `FakeDetectionStepper` (which is just a timed walk
 * through the steps).
 */
struct DetectionStepsView: View {
  
  @ObservedObject var stepper : FakeDetectionStepper
  
  var body: some View {
    VStack(spacing: 12) {
      ForEach(stepper.activeSteps) { step in
        StepView(step: step)
      }
    }
  }
  
  /**
   * Just a single step "badge".
   */
  struct StepView: View {
    
    let step : FakeDetectionStepper.ActiveStep
    
    var body: some View {
      HStack {
        if step.state != nil {
          Text(step.title)
          Spacer()
          Text(step.checkmark)
        }
        else {
          Spacer()
          Text(step.config.runTitle)
          Spacer()
        }
      }
      .font(.callout)
      .padding(16)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(style.lightShrugsBlue)
      )
    }
  }
}
