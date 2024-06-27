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
  @StateObject var viewModel = PhotoView.Model()
  //@State var image = UIImage()
  @State var overlay: String = ""
  
  var body: some View {
    VStack {
      Image(uiImage: viewModel.image)
        .resizable()
        .aspectRatio(contentMode: .fill)
//        .overlay {
//          if !overlay.isEmpty {
//            Image(systemName: overlay)
//          }
//        }
    }
    .task {
      guard let media = try? await loader() else {
        overlay = "camera.metering.unknown"
        return
      }
      switch media {
      case Media.photo(let image):
        viewModel.image = image
      default:
        print("default")
        overlay = "camera.metering.unknown"
      }
      return
    }
  }
}

extension PhotoView {
  class Model: ObservableObject {
    @Published var image = UIImage()
  }
}

//#Preview {
//  return PhotoView(loader: {
//    StubMediaLoader().file(LocalFiles.dog)})
//}
