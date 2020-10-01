//
//  PleaseDropAFileView.swift
//  5 GUIs
//
//  Created by Helge Heß on 28.09.20.
//

import SwiftUI

let appIcon = Bundle.main.image(forResource: "AppIcon")!

struct PleaseDropAFileView: View {
  
  var headlineText: some View {
    (Text("AppKit, Catalyst, iOS, SwiftUI or Web?\n")
      + Text("On which of the Five GUIs is a macOS app based on? Maybe all?"))
      .multilineTextAlignment(.center)
      .lineSpacing(8)
      .font(.system(size: 24, weight: .light, design: .default))
  }
  var centerText: some View {
    Text("Drop the application on this window to figure it out!")
      .multilineTextAlignment(.center)
      .lineSpacing(8.0)
      .font(.largeTitle)
  }
  var image: some View {
    Image(nsImage: appIcon)
      .frame(width: 128, height: 128) // this is the size?
      .padding(42)
      .shadow(color: Color(NSColor.init(deviceWhite: 1, alpha: 0.8)),
              radius: 10, x: 0, y: 0)
  }
  
  var body: some View {
    ZStack {
      //background
      
      VStack {
        headlineText
          .padding(48)
        Spacer()
      }
      
      VStack {
        Spacer()
        centerText
      }
      .padding(48)
      
      image
        .padding(48)
    }
  }
}
struct PleaseDropAFileView_Previews: PreviewProvider {
  static var previews: some View {
    PleaseDropAFileView()
      .frame(width: 480, height: 480, alignment: .center)
  }
}
