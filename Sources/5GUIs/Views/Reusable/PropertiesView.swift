//
//  PropertiesView.swift
//  5GUIs
//
//  Created by Helge Heß on 05.10.20.
//

import SwiftUI

struct PropertyLine: View {
  
  let name  : String
  let value : Any?
  var showMissing : Bool { false }
  
  var body: some View {
    Group {
      if showMissing {
        HStack {
          Text(name + ": ")
          Spacer()
          if let value = value {
            Text(verbatim: String(describing: value))
          }
          else {
            Text("-")
          }
        }
      }
      else {
        if let value = value {
          HStack {
            Text(name + ": ")
            Spacer()
            Text(verbatim: String(describing: value))
          }
        }
      }
    }
  }
}

struct PropertiesView: View {
  
  let properties : [ ( name: String, value: Any? ) ]
  
  var body: some View {
    Group {
      ForEach(properties, id: \.name) { item in
        PropertyLine(name: item.name, value: item.value)
      }
    }
  }
}

