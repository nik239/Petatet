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
  
  @Published var allPosts: [Post]?
  @Published var scrolledID: UUID?
  
  var indexForID = [UUID: Int]()
  var loadedMediaPosts = Set<UUID>()
  
  var scrollIDSub: AnyCancellable?
  
  var buffer: Int = 5
  
  init(container: DIContainer) {
    self.container = container
    self.apiService = container.services.APIService
    makeScrollIDPublisher()
  }
  
  func loadPosts() async {
    self.allPosts = try? await apiService.getPosts(accessToken: token, limit: 20)
    if let posts = self.allPosts {
      for (index, post) in posts.enumerated() {
        indexForID[post.id] = index
      }
    }
  }
  
  func makeScrollIDPublisher() {
    scrollIDSub = $scrolledID
      .removeDuplicates()
      .sink { id in
//        print("Scroll ID updated!")
//        print(id)
        guard let id = id else { return }
        guard let curr = self.indexForID[id] else { return }
        let upcoming =
        self.allPosts?[curr...curr+self.buffer].filter { !self.loadedMediaPosts.contains ($0.id) }
        upcoming?.forEach {
          self.loadMedia(post: $0)
        }
      }
  }
  
  private func loadMedia(post: Post) {
    // to-do: load all the media on the post into cache
    self.loadedMediaPosts.insert(post.id)
  }
}

extension FeedViewModel {
  struct LoadingBehavior {
    
  }
}
