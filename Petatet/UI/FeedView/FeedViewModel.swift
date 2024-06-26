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
  let appState: AppState
  let apiService: APIService
  let mediaLoader: MediaLoader
  
  @Published var allPosts: [Post]?
  @Published var scrolledID: UUID?
  var indexForID = [UUID: Int]()
  
  let loadBuffer: Int = 15
  let chunkSize: Int = 15
  
  var scrollIDSub: AnyCancellable?
  
  init(container: DIContainer) {
    self.appState = container.appState
    self.apiService = container.services.APIService
    self.mediaLoader = container.services.MediaLoader
    makeScrollIDPublisher()
    Task {
      self.allPosts = try? await apiService.getFeed(accessToken: appState.token,
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
      let nextChunk = try? await apiService.getFeed(accessToken: appState.token,
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
  func mediaLoaderClosure()
  -> (URL) async throws -> Media {
    return { try await self.mediaLoader.file($0) }
  }
  
  func likePostClosure(postID: String)
  -> () async throws -> () {
    return { try await self.apiService.likePost(accessToken: self.appState.token, postId: postID) }
  }
}
