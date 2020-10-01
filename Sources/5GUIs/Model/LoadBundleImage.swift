//
//  LoadBundleImage.swift
//  5 GUIs
//
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import class  Foundation.Bundle
import class  AppKit.NSImage
import class  AppKit.NSWorkspace
import struct SwiftUI.Image

/**
 * Try to load the image contained in an app bundle.
 * The info dict contains the name and/or location.
 *
 * If no image could be found, we fall back to what NSWorkspace provides
 * for the URL. (which seems to be a little small?)
 */
func loadImage(in info: InfoDict, bundle: Bundle) -> Image {
  let bundleImage : Image? = {
    // Note: `Image(name, bundle:)` is lazy.
    if let name    = info.iconName,
       let nsImage = bundle.image(forResource: name)
    {
      return Image(nsImage: nsImage)
    }
    guard let iconFile = info.iconFile else { // e.g. helper apps
      print("WARN: No image set?!"); return nil
    }
    if let nsImage = bundle.image(forResource: iconFile) { // TimeMachine
      return Image(nsImage: nsImage)
    }
    
    guard let path = bundle.path(forResource: iconFile, ofType: nil) else {
      print("ERROR: did not find:", iconFile); return nil
    }
    guard let nsImage = NSImage(contentsOfFile: path) else {
      print("ERROR: could not load image:", path); return nil
    }
    return Image(nsImage: nsImage)
  }()
  
  if let image = bundleImage {
    return image
  }
  
  // those are pretty small?
  return Image(nsImage: NSWorkspace.shared.icon(forFile: bundle.bundlePath))
}

