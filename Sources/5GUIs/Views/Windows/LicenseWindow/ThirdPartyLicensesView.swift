//
//  ThirdPartyLicensesView.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

fileprivate let licenses : String = {
  guard let url = Bundle.main
                .url(forResource: "LLVM-LICENSE", withExtension: "TXT") else {
    return "No licenses found?!"
  }
  do {
    return try String(contentsOf: url)
  }
  catch {
    print("ERROR: failed to load:", url.path, error)
    return "Failed to load licenses file!"
  }
}()

struct ThirdPartyLicensesView: View {
  
  var body: some View {
    ScrollView {
      VStack {
        Text("3rd Party Licenses")
          .font(.title)
        
        Divider()
        
        Text(verbatim: licenses)
          .multilineTextAlignment(.leading)
      }
      .padding()
    }
    .frame(minWidth  : 700, maxWidth  : 1024,
           minHeight : 320, maxHeight : 800)
  }
}

struct ThirdPartyLicensesView_Previews: PreviewProvider {
  static var previews: some View {
    ThirdPartyLicensesView()
  }
}
