//
//  FeedViewModel.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation
import Combine

final class RenderTable: ObservableObject {
  struct RenderData {
    var isRendered = false
    var renderWidth: CGFloat = 0
    var renderHeight: CGFloat = 0
  }
  
  @Published var renderTable = [UUID: RenderData]()
}

@MainActor 
final class FeedViewModel: ObservableObject {
  let token = "984370165166e874b086ace59c45a7e2173b539706b55575430a064e2379c922b0dad51688699875ad5ab36761669d6eadbaee691c4a1d22"
  
  let container: DIContainer
  let apiService: APIService
  let mediaLoader: MediaLoader
  let renderTable = RenderTable()
  
 // @Published var renderedPosts: [Post]?
  @Published var scrolledID: UUID?
  @Published var allPosts: [Post]?
  
  var indexForID = [UUID: Int]()
  
  //var loadedMediaPosts = Set<UUID>()
  
  var scrollIDSub: AnyCancellable?
  
  let renderBuffer: Int = 5
  let loadBuffer: Int = 10
  let chunkSize: Int = 10
  
  init(container: DIContainer) {
    self.container = container
    self.apiService = container.services.APIService
    self.mediaLoader = container.services.MediaLoader
//    Task {
//      await loadPosts()
//    }
    makeScrollIDPublisher()
  }
  
  func loadPosts() async {
    self.allPosts = try? await apiService.getFeed(accessToken: token,
                                                   limit: chunkSize,
                                                   afterPostID: nil)
    indexPosts()
    updateRendered(index: 0)
  }
  
  func indexPosts() {
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
        print("Scroll ID updated!")
//        print(id)
        guard let id = id else { return }
        guard let curr = self.indexForID[id] else { return }
        print("Current scroll index is: \(curr)")
        self.updateLoaded(index: curr)
        self.updateRendered(index: curr)
//        let upcoming = self.getUpcoming(curr: curr)
//        upcoming?.forEach {
//          self.loadMedia(post: $0)
//        }
      }
  }
  
  func updateLoaded(index: Int) {
    print("Running updateLoaded()")
    guard var allPosts = self.allPosts else {
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
  
  
  func updateRendered(index: Int) {
    guard var allPosts = self.allPosts else {
      return
    }
    
    let start = max(0, index - renderBuffer)
    var end = min(allPosts.count, index + renderBuffer + 1)
    if start == 0 {
      end = min(allPosts.count, 10)
    }
    
    for i in allPosts.indices {
      if renderTable.renderTable[allPosts[i].id] == nil {
        renderTable.renderTable[allPosts[i].id] = RenderTable.RenderData()
        print("Adding post to render table!")
      }
      if i >= start && i <= end {
        renderTable.renderTable[allPosts[i].id]?.isRendered = true
        print("Marking post as rendered!")
      } else {
        renderTable.renderTable[allPosts[i].id]?.isRendered = false
        print("Marking post as not rendered!")
      }
    }
    print(renderTable)
  }
  
//  func setRenderDimensions(forPostWithID id: UUID, width: CGFloat, height: CGFloat) {
//    guard let index = indexForID[id] else {
//      return
//    }
//    self.allPosts?[index].renderedWidth = width
//    self.allPosts?[index].renderedHeight = height
//    print("Set post width to: \(width)")
//    print("Set post height to: \(height)")
//  }
  
//  /// returns an array of posts upcoming in the scrollView
//  func getUpcoming(curr: Int) -> [Post]? {
//    guard let allPosts = self.allPosts else {
//      return nil
//    }
//    //handle edge cases
//    var endIndex = curr + buffer
//    if endIndex >= allPosts.endIndex {
//      endIndex = allPosts.endIndex - 1
//    }
//    //only return posts that haven't already been loaded
//    return allPosts[curr...endIndex].filter { !self.loadedMediaPosts.contains ($0.id)
//    }
//  }
//  
//  private func loadMedia(post: Post) {
//    print("loading media!")
//    switch post.attachedMedia {
//    case .photos(let urls):
//      urls.forEach { url in
//        Task {
//          try await mediaLoader.file(url)
//        }
//      }
//    case .photo(let url):
//      Task {
//        try await mediaLoader.file(url)
//      }
//    case .video(let url):
//      Task {
//        try await mediaLoader.file(url)
//      }
//    }
//    self.loadedMediaPosts.insert(post.id)
//  }
}

extension FeedViewModel {
  struct LoadingBehavior {
    
  }
}
