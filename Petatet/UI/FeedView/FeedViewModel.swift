//
//  FeedViewModel.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation
import Combine

@MainActor 
final class FeedViewModel: ObservableObject {
  let token = "984370165166e874b086ace59c45a7e2173b539706b55575430a064e2379c922b0dad51688699875ad5ab36761669d6eadbaee691c4a1d22"
  
  let container: DIContainer
  let apiService: APIService
  let mediaLoader: MediaLoader
  
  @Published var scrolledID: UUID?
  @Published var allPosts: [Post]?
  
  var indexForID = [UUID: Int]()
  
  var scrollIDSub: AnyCancellable?
  
  let loadBuffer: Int = 15
  let chunkSize: Int = 15
  
  init(container: DIContainer) {
    self.container = container
    self.apiService = container.services.APIService
    self.mediaLoader = container.services.MediaLoader
    makeScrollIDPublisher()
    Task {
      self.allPosts = try? await apiService.getFeed(accessToken: token,
                                                    limit: chunkSize,
                                                    afterPostID: nil)
      indexPosts()
    }
  }
  
  func makeScrollIDPublisher() {
    scrollIDSub = $scrolledID
      .removeDuplicates()
      .sink { id in
        guard let id = id else { return }
        guard let curr = self.indexForID[id] else { return }
        self.updateLoaded(index: curr)
      }
  }
  
  func updateLoaded(index: Int) {
    print("Running updateLoaded()")
    guard let allPosts = self.allPosts else {
      return
    }
    if index + loadBuffer < allPosts.endIndex {
      return
    }
    let lastPostID = allPosts.last?.postID
    Task {
      print("Loading posts!")
      let nextChunk = try? await apiService.getFeed(accessToken: token,
                                                     limit: chunkSize,
                                                     afterPostID: lastPostID)
      self.allPosts = allPosts + (nextChunk ?? [])
      indexPosts()
    }
  }
  
  func indexPosts() {
    if let posts = self.allPosts {
      for (index, post) in posts.enumerated() {
        indexForID[post.id] = index
      }
    }
  }
}

//MARK: - PostView Closure Builders
extension FeedViewModel {
  func loader()
  -> (URL) async throws -> Media {
    return { try await self.mediaLoader.file($0) }
  }
  
  func likePost(postID: String)
  -> () async throws -> () {
    return { try await self.apiService.likePost(accessToken: self.token, postId: postID) }
  }
}
