//
//  ProfileBarView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import SwiftUI

struct ScrollIndicator: View {
  @Binding var scrolledID: URL?
//  @State var currIndex: Int
  var spacing: CGFloat
  var urls: [URL]
  @State var firstURL: URL?
//  var count: Int
  
  var body: some View {
    HStack(spacing: spacing) {
      ForEach(urls) { url in
        if url == scrolledID || (scrolledID == nil && url == urls.first)  {
          Circle()
            .foregroundColor(.orange)
        } else {
          Circle()
            .foregroundColor(.gray)
        }
      }
      .onChange(of: scrolledID){
        guard let scrolledID = scrolledID else {
          print("scrolledID is nil!")
          return
        }
        print("scrollID is \(scrolledID)")
      }
    }
    .onAppear() {
      firstURL = urls.first
    }
//      .onChange(of: scrolledID, initial: true) { _, newVal in
//        self.currIndex = urls.firstIndex(of: newVal!)!
//      }
  }
}

extension ScrollIndicator {
  
}

//#Preview {
//  var urls = [LocalFiles.dog, LocalFiles.avatar, LocalFiles.longDog]
//  @State var scrolledID: URL? = LocalFiles.dog
//   return ScrollIndicator(scrolledID: $scrolledID,
// //                             currIndex: 0,
//                              spacing: 4,
//                              urls: urls)
//}
