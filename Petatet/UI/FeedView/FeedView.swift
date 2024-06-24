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
        ForEach(viewModel.allPosts ?? [], id: \.self) { post in
          PostView(post: post,
                   likeCount: post.likeCount,
                   renderTable: viewModel.renderTable,
                   viewModel: PostViewModel(container: viewModel.container))
          .id(post.id)
          .padding(.vertical)
        }
      }
      .scrollTargetLayout()
    }
    .scrollPosition(id: $viewModel.scrolledID)
    .task {
      await viewModel.loadPosts()
    }
  }
}

#Preview {
  FeedView(viewModel: FeedViewModel(container: .preview))
}
