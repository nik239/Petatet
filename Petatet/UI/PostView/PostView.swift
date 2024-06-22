//
//  Post.swift
//  Petatet
//
//  Created by Nikita Ivanov on 04/05/2024.
//

import SwiftUI
import AVKit

struct PostView: View {
  let post: Post
  @ObservedObject var renderTable: RenderTable
  var width: CGFloat = UIScreen.main.bounds.width
  @State var isLiked: Bool = false
  @State var isExpanded: Bool = false
  @ObservedObject var viewModel: PostViewModel
  @State var scrolledID: URL?
  @State var size: CGSize = .zero
  
  var body: some View {
//    if renderTable.renderTable[post.id]?.isRendered ?? false {
        ChildSizeReader(size: $size){
          VStack (alignment: .leading) {
            HStack {
              if let avatar = post.author?.avatar {
                PhotoView(loader: viewModel.loader(for: avatar))
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
                HStack(spacing: 0) {
                  ForEach(urls) { url in
                    PhotoView(loader: viewModel.loader(for: url))
                      .frame(width: width, height: width)
                      .clipped()
                  }
                }
                .scrollTargetLayout()
              }
              .scrollPosition(id: $scrolledID)
              .scrollTargetBehavior(.paging)
            case .photo(let url):
              PhotoView(loader: viewModel.loader(for: url))
                .frame(width: width, height: width)
                .clipped()
              
            case .video(let url):
              VideoView(loader: viewModel.loader(for: url))
                .frame(width: width, height: width)
                .clipped()
            }
            
            HStack {
              if isLiked {
                Image(systemName: "heart.fill")
                  .resizable()
                  .scaledToFit()
                  .frame(width: width * 0.065)
                  .foregroundColor(.orange)
                  .padding(.horizontal, width * 0.02)
                  .onTapGesture {
                    self.isLiked.toggle()
                  }
              } else {
                Image(systemName: "heart")
                  .resizable()
                  .scaledToFit()
                  .frame(width: width * 0.065)
                  .foregroundColor(.black)
                  .padding(.horizontal, width * 0.02)
                  .onTapGesture {
                    self.isLiked.toggle()
                  }
              }
              
              Spacer()
              
              switch post.attachedMedia{
              case .photos(let urls):
                ScrollIndicator(scrolledID: $scrolledID,
                                spacing: width * 0.01,
                                urls: urls)
                .frame(height: width * 0.02)
              default:
                EmptyView()
              }
              
              Spacer()
              
              Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.065)
                .foregroundColor(.orange)
                .padding(.horizontal, width * 0.02)
                .hidden()
            }
            
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
          .onAppear() {
            renderTable.renderTable[post.id]?.renderHeight = size.height
            renderTable.renderTable[post.id]?.renderWidth = size.width
            //setRenderDimensions(post.id, size.width, size.height)
            switch post.attachedMedia {
            case .photos(let urls):
              self.scrolledID = urls.first
            default:
              break
            }
          }
        }
//      } else {
//        Rectangle()
//          .frame(width: renderTable.renderTable[post.id]?.renderWidth,
//                 height: renderTable.renderTable[post.id]?.renderHeight)
//      }
  }
}


//#Preview {
//  PostView(post: PreviewPosts().posts[1],
//           viewModel: PostViewModel(container: .preview))
//}
