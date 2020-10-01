//
//  URLItems.swift
//  5 GUIs
//
//  Created by Helge Heß on 28.09.20.
//

import struct Foundation.Data
import struct Foundation.URL
import class  SwiftUI.NSItemProvider
import class  AppKit.RunLoop

enum UTI: String {
  case fileURL = "public.file-url"
}

extension NSItemProvider {
  
  func loadURL(forTypeIdentifier id: String = UTI.fileURL.rawValue,
               yield: @escaping ( URL? ) -> Void)
  {
    // this returns a `Progress`:
    loadItem(forTypeIdentifier: UTI.fileURL.rawValue, options: nil) {
      urlData, error in
      
      guard let urlData = urlData as? Data else {
        print("failed to load URL data:", error as Any) // TODO: how to log?
        return yield(nil)
      }
      
      guard let url = URL(dataRepresentation: urlData, relativeTo: nil) else {
        print("failed to decode URL data:", urlData)
        return yield(nil)
      }
      
      RunLoop.main.perform {
        yield(url)
      }
    }
  }
}

