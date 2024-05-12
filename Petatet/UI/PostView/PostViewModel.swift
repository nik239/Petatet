//
//  PostViewModel.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation

@MainActor
final class PostViewModel: ObservableObject {
  let mediaLoader: MediaLoader
  
  init(container: DIContainer) {
    self.mediaLoader = container.services.MediaLoader
  }
  
  func loader(for url: URL, isVideo: Bool)
  -> () async throws -> Media {
    return { try await self.mediaLoader.file(url, isVideo: isVideo) }
  }
}
