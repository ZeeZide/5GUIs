//
//  MainFileView.swift
//  5 GUIs
//
//  Created by Helge Heß on 28.09.20.
//

import SwiftUI

struct MainFileView: View {
  
  @ObservedObject var stepper : FakeDetectionStepper
  @ObservedObject var state   : BundleFeatureDetectionOperation
  
  @State private var detailsVisible = false
  
  private var appName : String { state.info.appName }
  
  private var topImage : some View {
    state.info.appImage?
      .resizable(capInsets: .init(), resizingMode: .stretch)
      .frame(width: 128, height: 128, alignment: .center)
  }
  
  var body: some View {
    ZStack {
      if state.state == .processing {
        SpinnerView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      if state.state == .processing {
        Text("Analyzing …")
          .padding(.top, 110)
          .font(.callout)
      }

      VStack {
        topImage
          .popover(isPresented: $detailsVisible, arrowEdge: .bottom) {
            ScrollView {
              DetailsPopover(info: state.info)
            }
            .frame(minWidth: 480, maxWidth: .infinity, minHeight: 320)
          }
          .padding(.top)
          .onTapGesture {
            detailsVisible = true
          }

        Text("\(appName)")
          .font(.largeTitle)
        
        Spacer()
        
        if state.state == .finished && stepper.isDone {
          SummaryView(info: state.info)
            .padding(.horizontal)
        }

        Spacer()
        
        DetectionStepsView(stepper: stepper)
          .padding()
      }
    }
  }
}
