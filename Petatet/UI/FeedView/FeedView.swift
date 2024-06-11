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
      VStack (alignment: .leading) {
        ForEach(viewModel.allPosts ?? []) { post in
          PostView(post: post,
                   viewModel: PostViewModel(container: viewModel.container))
          .padding(.vertical)
          //.id(post.id)
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
