//
//  NewPostViewModel.swift
//  Petatet
//
//  Created by Nikita Ivanov on 22/06/2024.
//

import Foundation
import PhotosUI
import SwiftUI
import Combine

enum NewPostViewState {
  case neutral
  case typingCaption
}

enum PickerState {
  case neutral
  case presentingPhotos
  case presentingVideo
}

@MainActor
final class NewPostViewModel: ObservableObject {
  let appState: AppState
  let apiService: APIService
  
  @Published var viewState: NewPostViewState = .neutral
  
  let placeHolder = "Write a caption..."
  @Published var userInput: String = "Write a caption..."
  
  @Published var pickerState: PickerState = .neutral
  
  var subs = Set<AnyCancellable>()
  
  var images: [Data] = []
  var video: Data? = nil
  var player: AVPlayer? = nil
  
  @Published var isValid: Bool = false
  
  init(container: DIContainer) {
    self.apiService = container.services.APIService
    self.appState = container.appState
  }
  
  func loadImages(photoItems: [PhotosPickerItem]) {
    guard photoItems != [] else {
      return
    }
    print("Have selected photos")
    Task {
      for item in photoItems {
        let imageData = try await item.loadTransferable(type: Data.self)
        guard let image = imageData else {
          return
        }
        self.images.append(image)
      }
      self.pickerState = .presentingPhotos
    }
  }
  
  func loadVideo(videoItem: PhotosPickerItem?) {
    guard let videoItem = videoItem else {
      return
    }
    print("Have selected video")
    
    Task {
      self.video = try await videoItem.loadTransferable(type: Data.self)
      guard let video = video else {
        print("Couldn't load video from photos library!")
        return
      }
      let item = await self.createAVAsset(from: video)
      self.player = AVPlayer(playerItem: item)
      self.pickerState = .presentingVideo
    }
  }
  
  func createAVAsset(from data: Data) async -> AVPlayerItem? {
    // Step 1: Create a temporary file URL
    let tempDir = FileManager.default.temporaryDirectory
    let tempFileURL =
    tempDir
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension("mov")
    
    do {
      try data.write(to: tempFileURL)
      let asset = AVAsset(url: tempFileURL)
      _ = try! await asset.load(.tracks,
                               .duration,
                               .isPlayable,
                               .isExportable,
                               .isReadable)
      let item = AVPlayerItem(asset: asset)
      return item
    } catch {
      return nil
    }
  }
  
  func clearMediaSelection() {
    self.images = []
    self.video = nil
    self.pickerState = .neutral
  }
  
  func uploadPost() {
    if self.video != nil {
      Task {
        try await apiService.newPost(accessToken: appState.token,
                                    userID: appState.uid,
                                     postText: self.userInput,
                                     images: nil,
                                     video: self.video)
        clearMediaSelection()
      }
      return
    }
    
    if self.images != [] {
      Task {
        try await apiService.newPost(accessToken: appState.token,
                                     userID: appState.uid,
                                     postText: self.userInput,
                                     images: images,
                                     video: nil)
        clearMediaSelection()
      }
      return
    }
    
    Task {
      try await apiService.newPost(accessToken: appState.token,
                                   userID: appState.uid,
                                   postText: self.userInput,
                                   images: nil,
                                   video: nil)
      clearMediaSelection()
    }
  }
  
//  func makeSelectedMediaPublishers() {
//    $selectedPhotos
//      .removeDuplicates()
//      .sink { photoItems in
//        print("Have selected photos")
//        guard photoItems != [] else {
//          return
//        }
//        
//        for item in photoItems {
//          Task {
//            let imageData = try await item.loadTransferable(type: Data.self)
//            guard let image = imageData else {
//              return
//            }
//            self.images.append(image)
//          }
//        }
//        print("Have selected photos!")
//        self.pickerState = .presentingPhotos
//      }
//      .store(in: &subs)
    
//    $selectedVideo
//      .removeDuplicates()
//      .sink { videoItem in
//        guard let item = videoItem else {
//          return
//        }
//        
//        Task {
//          let videoData = try await item.loadTransferable(type: Data.self)
//          guard let video = videoData else {
//            return
//          }
//          self.video = video
//        }
//
//        self.pickerState = .presentingVideo
//      }
//      .store(in: &subs)
//  }
}

//MARK: - UI
extension NewPostViewModel {
//  var backgroundColor: Color {
//    switch self.viewState {
//    case .neutral:
//      return .white
//    case .typingCaption:
//      return .gray
//    }
//  }
}
