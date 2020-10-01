//
//  Style.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct Style {

  let textColor = Color.white
  
  // 0x0068DA (Shrugs Website)
  let lightShrugsBlue = Color(red: 0, green: 104/255, blue: 218/255)
  let darkShrugsBlue  = Color(red: 0, green: 37/255, blue: 77/255)
    // 0x00254D vs .black

  var baseGradient : Gradient {
    .init(colors: [
      lightShrugsBlue,
      darkShrugsBlue,
    ])
  }

  var baseFillGradient : LinearGradient {
    LinearGradient(gradient: baseGradient,
                   startPoint: .top, endPoint: .bottom)
  }
  var hoverFillGradient : LinearGradient {
    LinearGradient(gradient: baseGradient,
                   startPoint : UnitPoint(x: 0, y: 0.5),
                   endPoint   : UnitPoint(x: 1, y: 1))
  }

}
let style = Style()
