//
//  ImagesView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 23/06/2024.
//

import SwiftUI

struct ImagesView: View {
  let data: [Data]
  @State var images: [UIImage]?
  var body: some View {
    GeometryReader{ geometry in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 0) {
          ForEach(images ?? []) { image in
            ImageView(image: image)
              .frame(width: geometry.size.width, height: geometry.size.width)
              .clipped()
          }
        }
      }
      .scrollTargetBehavior(.paging)
      .task {
        self.images = data.map {
          return UIImage(data: $0) ?? UIImage(systemName: "camera.metering.unknown")!
        }
      }
    }
  }
}

extension UIImage: Identifiable {
  
}

//#Preview {
//  ImagesView()
//}
