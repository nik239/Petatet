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
    VStack (alignment: .leading) {
      ScrollView(.vertical, showsIndicators: false) {
        ForEach(viewModel.posts ?? []) { post in
          PostView(post: post,
                   viewModel: PostViewModel(container: viewModel.container))
            .padding(.vertical)
        }
      }
    }
    .task {
      await viewModel.loadPosts()
    }
  }
}

#Preview {
  FeedView(viewModel: FeedViewModel(container: .preview))
}
