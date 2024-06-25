//
//  PostBottomBar.swift
//  Petatet
//
//  Created by Nikita Ivanov on 23/06/2024.
//

import SwiftUI

struct PostBottomBar: View {
  let width: CGFloat
  @State var attachedMedia: AttachedMedia
  @Binding var isLiked: Bool
  @Binding var likeCount: Int
  @Binding var scrolledID: URL?
  let likeAction: () async throws -> ()
  
  var body: some View {
    ZStack {
      switch attachedMedia{
      case .photos(let urls):
        ScrollIndicator(scrolledID: $scrolledID,
                        spacing: width * 0.01,
                        urls: urls)
        .frame(height: width * 0.02)
      default:
        EmptyView()
      }
      HStack {
        if isLiked {
          Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
            .frame(width: width * 0.065)
            .foregroundColor(.orange)
            .padding(.leading, width * 0.02)
            .onTapGesture {
              self.isLiked.toggle()
              Task {
                try await likeAction()
              }
              likeCount -= 1
            }
        } else {
          Image(systemName: "heart")
            .resizable()
            .scaledToFit()
            .frame(width: width * 0.065)
            .foregroundColor(.black)
            .padding(.leading, width * 0.02)
            .onTapGesture {
              self.isLiked.toggle()
              Task {
                try await likeAction()
              }
              likeCount += 1
            }
        }
        
        if likeCount != 0 {
          HStack {
            Text("\(likeCount)")
              .bold()
              //.padding(.leading)
            if likeCount == 1 {
              Text("like")
            } else {
              Text("likes")
            }
          }
        }
        
        Spacer()
      }
    }
  }
}

//#Preview {
//    PostBottomBar()
//}
