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
  var postOrder = [UUID: Int]()
  @Published var displayedPosts: [Post]?
  @Published var scrolledID: UUID?
  
  var displayed: Int = 0
  var buffer: Int = 5
  
  init(container: DIContainer) {
    self.container = container
    self.apiService = container.services.APIService
  }
  
  func loadPosts() async {
    self.allPosts = try? await apiService.getPosts(accessToken: token, limit: 20)
    if let posts = self.allPosts {
      for (index, post) in posts.enumerated() {
        postOrder[post.id] = index
      }
    }
  }
  
  func makeScrollIDPublisher() {
    $scrolledID
      .sink { id in
        if let id = id, let index = self.postOrder[id] {
          
        }
      }
  }
  
  private func loadMedia() async {
    
  }
}

extension FeedViewModel {
  struct LoadingBehavior {
    
  }
}
