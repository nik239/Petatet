//
//  FeedViewModel.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation
import Combine

enum FeedType {
  case main
  case catsForAdoption
  case dogsForAdoption
  case profile
}

@MainActor
final class FeedViewModel: ObservableObject {
  let appState: AppState
  let apiService: APIService
  let mediaLoader: MediaLoader
  
  let feedType: FeedType
  let postLoader: (String?) async throws -> [Post]?
  
  @Published var allPosts: [Post]?
  @Published var scrolledID: UUID?
  var indexForID = [UUID: Int]()
  
  let loadBuffer: Int = 15
  let chunkSize: Int = 15
  
  var scrollIDSub: AnyCancellable?
  var appStateSub: AnyCancellable?
  
  init(container: DIContainer, type: FeedType) {
    self.appState = container.appState
    self.apiService = container.services.APIService
    self.mediaLoader = container.services.MediaLoader
    self.feedType = type
    self.postLoader = FeedViewModel.getPostLoader(for: type,
                                                  appState: appState,
                                                  apiService: apiService,
                                                  chunkSize: chunkSize)
    //makeScrollIDPublisher()
    fetchPosts()
  }
  
//  func makeScrollIDPublisher() {
//    scrollIDSub = $scrolledID
//      .removeDuplicates()
//      .sink { id in
//        guard let id = id else { return }
//        guard let curr = self.indexForID[id] else { return }
//        self.updateLoaded(index: curr)
//      }
//  }
  
  func updateCurr(id: UUID) {
    guard let curr = self.indexForID[id] else { return }
    self.updateLoaded(index: curr)
  }
  
  func makeAuthSub() {
    appStateSub = appState.$authState
      .removeDuplicates()
      .sink { authState in
        self.fetchPosts()
      }
  }
  
  func fetchPosts() {
    Task {
      self.allPosts = try? await postLoader(nil)
      indexPosts()
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
      let nextChunk = try? await postLoader(lastPostID)
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

//MARK: - postLoader constructor
extension FeedViewModel {
  static func getPostLoader(for type: FeedType,
                            appState: AppState,
                            apiService: APIService,
                            chunkSize: Int) -> (String?) async throws -> [Post]? {
    switch type {
    case .main:
      return {
        try await apiService.getFeed(accessToken: appState.token,
                                     limit: chunkSize,
                                     afterPostID: $0)
      }
    case .catsForAdoption:
      return {
        try await apiService.getAnimalsForAdoption(accessToken: appState.token,
                                                   limit: chunkSize,
                                                   afterPostID: $0,
                                                   getCats: true)
      }
    case .dogsForAdoption:
      return {
        try await apiService.getAnimalsForAdoption(accessToken: appState.token,
                                                   limit: chunkSize,
                                                   afterPostID: $0,
                                                   getCats: false)
      }
    case .profile:
      return {
        try await apiService.getUserPosts(accessToken: appState.token,
                                          limit: chunkSize,
                                          afterPostID: $0,
                                          uid: appState.uid)
      }
    }
  }
}

