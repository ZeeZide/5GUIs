//
//  SpinnerView.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct SpinnerView: View {

  struct ContentView: View {
    
    var body: some View {
      Circle()
        .trim(from: 0, to: 0.8) // cut out a segment of the circle
        .stroke(
          AngularGradient(
            gradient: style.baseGradient,
            center: .center
          ),
          style: StrokeStyle(lineWidth: 8, lineCap: .round)
        )
        .frame(width: 45, height: 45)
    }
  }
  
  @State var animates = false
    // This is necessary! Why? To trigger the animation we need to
    // transition the View from one state to another.
    // We don't need to constantly toggle, this is what
    // `repeatForever` does for us automagically.
    // This needs to be an '@State', because the view (`self`) is
    // immutable within `onAppear`.

  var body: some View {
    ContentView()
      .rotationEffect(.init(degrees: animates ? 360 : 0),
                            anchor: .center)
      .animation(
        Animation.linear(duration: 0.7)
          .repeatForever(autoreverses: false)
      )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
      // required?! otherwise the circle "flies in"
    .padding(24)
    .onAppear { self.animates = true }
  }
}

struct SpinnerView_Previews: PreviewProvider {
  static var previews: some View {
    SpinnerView()
  }
}
