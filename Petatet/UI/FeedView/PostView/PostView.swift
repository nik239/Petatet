//
//  Post.swift
//  Petatet
//
//  Created by Nikita Ivanov on 04/05/2024.
//

import SwiftUI

struct PostView: View {
  @State var post: Post
  let loader: (URL) async throws -> Media
  let likePost: () async throws -> ()

  @State var isLiked: Bool = false
  @State var scrolledID: URL?
  @State var isExpanded: Bool = false
  
  var width: CGFloat = UIScreen.main.bounds.width
  
  var body: some View {
    VStack (alignment: .leading) {
      HStack {
        if let avatar = post.author?.avatar {
          PhotoView(loader: {try await loader(avatar)})
            .frame(width: width * 0.1, height: width * 0.1)
            .clipShape(.circle)
            .padding(.horizontal, width * 0.02)
        }
        if let name = post.author?.displayName {
          Text(name)
            .bold()
        }
        Spacer()
      }
      
      switch post.attachedMedia {
      case .photos(let urls):
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 0) {
            ForEach(urls) { url in
              PhotoView(loader: {try await loader(url)})
                .frame(width: width, height: width)
                .clipped()
            }
          }
          .scrollTargetLayout()
        }
        .scrollPosition(id: $scrolledID)
        .scrollTargetBehavior(.paging)
      case .photo(let url):
        PhotoView(loader: {try await loader(url)})
          .frame(width: width, height: width)
          .clipped()
      case .video(let url):
        VideoView(loader: {try await loader(url)})
          .frame(width: width, height: width)
          .clipped()
      }
      
      PostBottomBar(width: width,
                    attachedMedia: post.attachedMedia,
                    isLiked: $isLiked,
                    likeCount: $post.likeCount,
                    scrolledID: $scrolledID,
                    likeAction: likePost)
      
      if isExpanded {
        Text(post.postText ?? "")
          .padding()
      } else {
        VStack(alignment: .leading) {
          Text(post.postText ?? "")
            .lineLimit(2)
          Text("more")
            .foregroundColor(.gray)
        }
        .onTapGesture {
          self.isExpanded = true
        }
        .padding(.horizontal, width * 0.02)
      }
    }
  }
}


//#Preview {
//  PostView(post: PreviewPosts().posts[1],
//           likeCount: 1,
//          // renderData: RenderData(),
//           viewModel: PostViewModel(container: .preview))
//}
