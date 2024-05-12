//
//  FeedViewModel.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation

@MainActor 
final class FeedViewModel: ObservableObject {
  let token = "984370165166e874b086ace59c45a7e2173b539706b55575430a064e2379c922b0dad51688699875ad5ab36761669d6eadbaee691c4a1d22"
  
  let container: DIContainer
  
  @Published var posts: [Post]?
  
  let APIService: APIService
  
  init(container: DIContainer) {
    self.container = container
    self.APIService = container.services.APIService
  }
  
  func loadPosts() async {
    self.posts = try? await APIService.getPosts(accessToken: token,
                                                limit: 19,
                                                offSet: "")
  }
}
