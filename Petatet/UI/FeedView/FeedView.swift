//
//  FeedView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 04/05/2024.
//

import SwiftUI

struct FeedView: View {
  @ObservedObject var viewModel: FeedViewModel
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVStack (alignment: .leading) {
        ForEach(viewModel.allPosts ?? []) { post in
          PostView(post: post,
                   loader: self.viewModel.mediaLoaderClosure(),
                   likePost: viewModel.likePostClosure(postID: post.postID ?? ""))
                   
          .padding(.vertical)
        }
      }
      .scrollTargetLayout()
    }
    .scrollPosition(id: $viewModel.scrolledID)
  }
}

#Preview {
  FeedView(viewModel: FeedViewModel(container: .preview))
}
