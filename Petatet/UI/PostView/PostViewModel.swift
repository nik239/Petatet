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
  let apiService: APIService
  let token = "984370165166e874b086ace59c45a7e2173b539706b55575430a064e2379c922b0dad51688699875ad5ab36761669d6eadbaee691c4a1d22"
//  let post: Post
//  @Published var scrolledID: URL?
  
  init(container: DIContainer) {
//    self.post = post
    self.mediaLoader = container.services.MediaLoader
    self.apiService = container.services.APIService
  }
  
  func loader(for url: URL)
  -> () async throws -> Media {
    return { try await self.mediaLoader.file(url) }
  }
  
  func likePost(postID: String) {
    Task {
      try await apiService.likePost(accessToken: token, postId: postID)
    }
  }
}
