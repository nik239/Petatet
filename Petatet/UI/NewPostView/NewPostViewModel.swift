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
  let apiService: APIService
  
  @Published var viewState: NewPostViewState = .neutral
  
  let placeHolder = "Write a caption..."
  @Published var userInput: String = "Write a caption..."
  
  @Published var pickerState: PickerState = .neutral
  @Published var selectedPhotos: [PhotosPickerItem] = []
  @Published var selectedVideo: PhotosPickerItem? = nil
  var subs = Set<AnyCancellable>()
  
  var images: [Data] = []
  var video: Data? = nil
  
  @Published var isValid: Bool = false
  
  init(container: DIContainer) {
    self.apiService = container.services.APIService
  }
  
  func makeSelectedMediaPublishers() {
    $selectedPhotos
      .removeDuplicates()
      .sink { photoItems in
        guard photoItems != [] else {
          return
        }
        
        for item in photoItems {
          Task {
            let imageData = try await item.loadTransferable(type: Data.self)
            guard let image = imageData else {
              return
            }
            self.images.append(image)
          }
        }

        self.pickerState = .presentingPhotos
      }
      .store(in: &subs)
    
    $selectedVideo
      .removeDuplicates()
      .sink { videoItem in
        guard let item = videoItem else {
          return
        }
        
        Task {
          let videoData = try await item.loadTransferable(type: Data.self)
          guard let video = videoData else {
            return
          }
          self.video = video
        }

        self.pickerState = .presentingVideo
      }
      .store(in: &subs)
  }
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
