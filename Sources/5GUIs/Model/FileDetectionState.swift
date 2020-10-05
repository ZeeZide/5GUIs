//
//  FileDetectionState.swift
//  5 GUIs
//
//  Created by Helge Heß on 28.09.20.
//

import SwiftUI

protocol FileDetectionStateDelegate: AnyObject {
  func detectionStateDidChange(_ state: FileDetectionState)
}

/**
 * This is the main "operation" object which runs from a background queue and
 * collects all the info we want.
 */
final class FileDetectionState: ObservableObject {
  // FIXME: this is more like a 'load operation'
  // TBD: if this goes away, we could keep a global URL => State mapping
  
  weak var delegate : FileDetectionStateDelegate?
    
  enum State: Equatable {
    case processing
    case failedToOpen(Swift.Error?)
    case notAnApplication
    case finished
    static func == (lhs: State, rhs: State) -> Bool {
      switch ( lhs, rhs ) {
        case ( .processing       , .processing       ): return true
        case ( .failedToOpen     , .failedToOpen     ): return true
        case ( .notAnApplication , .notAnApplication ): return true
        case ( .finished         , .finished         ): return true
        default: return false
      }
    }
  }
  
  let fm  = FileManager.default

  @Published var state = State.processing {
    didSet {
      delegate?.detectionStateDidChange(self)
    }
  }
  @Published var info : ExecutableFileTechnologyInfo {
    didSet {
      delegate?.detectionStateDidChange(self)
    }
  }
  @Published var otoolAvailable = true

  var url : URL { info.fileURL }
  
  init(_ url: URL) {
    self.info = ExecutableFileTechnologyInfo(fileURL: url)
  }
  func resume() {
    DispatchQueue.global().async {
      self.startWork()
    }
  }
  
  
  // MARK: - Just some threadsafe helpers ...
  
  private func apply(_ block: @escaping () -> Void) {
    RunLoop.main.perform(block)
  }
  private func apply<V>(_ keyPath:
                            ReferenceWritableKeyPath<FileDetectionState, V>,
                        _ value: V)
  {
    apply {
      self[keyPath: keyPath] = value
    }
  }
  private func applyState(_ state: State) { // Q: Any
    apply(\.state, state)
  }
  
  
  // MARK: - Main Entry
  
  private func startWork() { // Q: background
    
    var isDir : ObjCBool = false
    guard fm.fileExists(atPath: url.path, isDirectory: &isDir) else {
      return applyState(.failedToOpen(nil))
    }
   
    if isDir.boolValue {
      processWrapper(url)
    }
    else {
      processFile(url)
    }
  }
  
  
  // MARK: - Workers
  
  private func processFile(_ url: URL) {
    guard fm.isExecutableFile(atPath: url.path) else {
      return applyState(.notAnApplication)
    }
    
    // TODO: grab Info.plist embedded in Mach-O
    
    apply(\.info.executableURL, url)
    
    processExecutable(url)
    
    applyState(.finished)
  }
  
  private func processWrapper(_ url: URL) { // Q: Any
    guard let bundle = Bundle(url: url) else {
      print("could not open bundle:", url)
      return applyState(.failedToOpen(nil))
    }
    
    let info = InfoDict(bundle.infoDictionary ?? [:])
    
    guard let executableURL = bundle.executableURL else {
      print("no executable in bundle:", bundle)
      return applyState(.notAnApplication)
    }
    let receiptURL = bundle.appStoreReceiptURL
    
    apply {
      self.info.executableURL  = executableURL
      self.info.receiptURL     = receiptURL
      self.info.infoDictionary = info
    }
    
    let image = loadImage(in: info, bundle: bundle)
    apply(\.info.appImage, image)
    
    processExecutable(executableURL)
    
    processDirectoryContents(url)

    self.applyState(.finished)
  }
  
  
  // MARK: - Individual Workers
  
  private func processExecutable(_ executableURL: URL) { // Q: Any
    do {
      let dependencies = try otool(executableURL)
      
      // scan in this bg thread
      var detectedFeatures = ExecutableFileTechnologyInfo.DetectedTechnologies()
      detectedFeatures.scanDependencies(dependencies)
      
      apply {
        self.otoolAvailable = true
        self.info.dependencies = dependencies
        self.info.detectedTechnologies.formUnion(detectedFeatures)
      }
    }
    catch {
      print("Could not invoke OTool:", error)
      apply(\.otoolAvailable, false)
    }
  }
  
  private func processDirectoryContents(_ url: URL) { // Q: Any
    var detectedFeatures = ExecutableFileTechnologyInfo.DetectedTechnologies()
    let contents = url.appendingPathComponent("Contents")
    
    // Charles & Eclipse
    for pc in [ "Java", "Eclipse" ] {
      let suburl = contents.appendingPathComponent(pc)
      if fm.fileExists(atPath: suburl.path) {
        detectedFeatures.insert(.java)
        break
      }
    }
    // JD-GUI
    if self.info.infoDictionary?.JavaX != nil {
      detectedFeatures.insert(.java)
    }
    
    do { // Electron apps seem to have this ...
      let suburl = contents.appendingPathComponent("Resources/app.asar")
      if fm.fileExists(atPath: suburl.path) {
        detectedFeatures.insert(.electron)
      }
    }

    // scan the Frameworks directory
    do {
      let suburl  = contents.appendingPathComponent("Frameworks")
      let files =
        try fm.contentsOfDirectory(at: suburl, includingPropertiesForKeys: nil,
                                   options: .skipsSubdirectoryDescendants)
          .map { $0.lastPathComponent }
          .sorted()

      for filename in files {
        if filename.hasPrefix("libwx_") {
          detectedFeatures.insert(.wxWidgets)
        }
        else if filename == "python-extensions" {
          detectedFeatures.insert(.python)
        }
      }
    }
    catch {
      print("ERROR: ignoring framework scan error:", error)
    }
    
    if !detectedFeatures.isEmpty {
      apply {
        self.info.detectedTechnologies.formUnion(detectedFeatures)
      }
    }
  }
  
  // MARK: - Results
  
  // Our "5 GUIs"
  var analysisResults : [ FakeStep ] {
    func make(_ feature : ExecutableFileTechnologyInfo.DetectedTechnologies,
              _ config  : FakeStepConfig) -> FakeStep
    {
      .init(config: config, state: info.detectedTechnologies.contains(feature))
    }
    
    let isPhone = info.detectedTechnologies.contains(.uikit)
             && !(info.detectedTechnologies.contains(.catalyst))
    
    return [
      make(.electron, .electron),
      make(.catalyst, .catalyst),
      make(.swiftui,  .swiftUI),
      .init(config: .phone, state: isPhone),
      make(.appkit, .appKit) // TBD: only report if others don't match?
    ]
  }
}
