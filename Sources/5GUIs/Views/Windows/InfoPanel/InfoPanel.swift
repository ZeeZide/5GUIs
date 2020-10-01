//
//  InfoPanel.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

fileprivate let licenseWindow =
  makeLicenseWindow(ThirdPartyLicensesView())

struct InfoPanel: View {
  
  private struct Content: View {

    private var image: some View {
      Image(nsImage: appIcon)
        .frame(width: 64, height: 64) // this is the size?
        .padding(.top)
        .shadow(color: Color(NSColor.init(deviceWhite: 1, alpha: 0.8)),
                radius: 10, x: 0, y: 0)
    }
    
    var body: some View {
      VStack(spacing: 16) {
        Text("Used 3rd Party Software…")
          .onTapGesture { licenseWindow.makeKeyAndOrderFront(nil) }
          .font(.subheadline)
        
        (Text("©2020 ") + Text("ZeeZide").bold() + Text(" GmbH"))
          .openLink("https://zeezide.com")
          .font(.title)
        
        Text("… the app for the tweet!")
          .font(.callout)
          .openLink(
            "https://twitter.com/jckarter/status/1310412969289773056")

        Spacer()
        
        image
          .openLink("https://en.wikipedia.org/wiki/Graphical_user_interface")
        
        Spacer()

        Text(
          """
          How it works:
          5 GUIs grabs some information from the app bundle. It then
          uses LLVM's objdump to check what libraries the app links,
          e.g. Electron or UIKit, to figure out what technology
          is being used.
          5 GUIs itself is a SwiftUI application available as OpenSource at the
          ZeeZide GitHub repository.
          """
          .replacingOccurrences(of: "\n", with: " ")
        ).font(.body).multilineTextAlignment(.leading)
      }
      .padding(.top, 10)
      .multilineTextAlignment(.center)
      .lineSpacing(8)
      .font(.title)
    }
  }
  
  var body: some View {
    Content()
      .padding()
      .foregroundColor(style.textColor)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(style.baseFillGradient)
      .edgesIgnoringSafeArea(.all)
  }
}

fileprivate extension View {
  
  func openLink(_ s: String) -> some View {
    return onTapGesture {
      guard let url = URL(string: s) else {
        assertionFailure("Invalid URL")
        return print("ERROR: can't parse URL:", s)
      }
      NSWorkspace.shared.open(url)
    }
  }
}

struct InfoPanel_Previews: PreviewProvider {
  static var previews: some View {
    InfoPanel()
      .frame(width: 320, height: 320)
  }
}
