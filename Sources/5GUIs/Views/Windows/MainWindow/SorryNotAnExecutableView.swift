//
//  SorryNotAnExecutableView.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct SorryNotAnExecutableView: View {
  
  let url : URL
  
  var headlineText: some View {
    (Text("The file your dropped doesn't seem to be an application?") +
     Text(" You can find some apps in the /Applications folder.")
    )
    .multilineTextAlignment(.center)
    .lineSpacing(8)
    .font(.system(size: 24, weight: .light, design: .default))
  }
  var centerText: some View {
    Text("Give it another try!")
      .multilineTextAlignment(.center)
      .lineSpacing(8.0)
      .font(.largeTitle)
  }

  var image: some View {
    VStack {
      Image(nsImage: NSWorkspace.shared.icon(forFile: url.path))
      Text(verbatim: "“\(url.lastPathComponent)”")
        .font(.title)
    }
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

// /Users/helge/Desktop/Kaffee

struct SorryNotAnExecutableView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SorryNotAnExecutableView(
        url:
          URL(fileURLWithPath: "/Users/helge/Desktop/Excellent-frog.jpg")
      )
      .frame(width: 480, height: 480, alignment: .center)
      
      SorryNotAnExecutableView(
        url:
          URL(fileURLWithPath: "/Users/helge/Desktop/Kaffee")
      )
      .frame(width: 480, height: 480, alignment: .center)
    }
  }
}
