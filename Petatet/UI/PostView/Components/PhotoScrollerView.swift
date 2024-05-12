//
//  PhotoScrollerView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 06/05/2024.
//

//import SwiftUI
//
//struct PhotoScrollerView: View {
//  var photoURLs: [URL]
//  var width: CGFloat = UIScreen.main.bounds.width
//  @State var currIndex = 0
//  
//  var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//          ScrollViewReader { proxy in
//            HStack(spacing: 0) {
//              ForEach(photoURLs) { url in
//                PhotoView(url: url)
//                  .frame(width: width, height: width)
//                  .id(url)
//              }
//            }
//          }
//        }
//        .scrollTargetBehavior(.paging)
//  }
//}

//#Preview {
//    PhotoScrollerView()
//}
