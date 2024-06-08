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
//  let post: Post
//  @Published var scrolledID: URL?
  
  init(container: DIContainer) {
//    self.post = post
    self.mediaLoader = container.services.MediaLoader
  }
  
  func loader(for url: URL)
  -> () async throws -> Media {
    return { try await self.mediaLoader.file(url) }
  }
}
