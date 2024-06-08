//
//  MediaView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 04/05/2024.
//

import SwiftUI
import UIKit

struct PhotoView: View {
  let loader: () async throws -> Media

  @State var image = UIImage()
  @State var overlay = ""
  
  var body: some View {
    Image(uiImage: image)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .overlay {
        if !overlay.isEmpty {
          Image(systemName: overlay)
        }
      }
      .task {
        guard let media = try? await loader() else {
          overlay = "camera.metering.unknown"
          return
        }
        switch media {
        case Media.photo(let image):
          self.image = image
        default:
          overlay = "camera.metering.unknown"
        }
        return
      }
  }
}

#Preview {
  return PhotoView(loader: {
    StubMediaLoader().file(LocalFiles.dog)})
}
