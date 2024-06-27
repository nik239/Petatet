//
//  PhotosView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/06/2024.
//

import SwiftUI

struct PhotosView: View {
  @StateObject var viewModel: PhotosView.Model
  let image = UIImage()
  let width: CGFloat
  @Binding var scrolledID: URL?
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 0) {
        ForEach(viewModel.urls) { url in
          if viewModel.images[url] != nil {
            Image(uiImage: (viewModel.images[url] ?? image)!)
              .frame(width: width, height: width)
              .clipped()
          }
        }
      }
      .scrollTargetLayout()
    }
    .scrollPosition(id: $scrolledID)
    .scrollTargetBehavior(.paging)
  }
}

extension PhotosView {
  final class Model: ObservableObject {
    @Published var images: [URL: UIImage] = [:]
    @Published var urls: [URL]
    let loader: (URL) async throws -> Media
    init(urls: [URL], loader: @escaping (URL) async throws -> Media) {
      self.urls = urls
      self.loader = loader
      urls.forEach { url in
        Task {
          guard let media = try? await loader(url) else {
            return
          }
          switch media {
          case Media.photo(let image):
            await MainActor.run {
              images[url] = image
            }
          default:
            return
          }
        }
      }
    }
  }
}

//#Preview {
//  PhotosView()
//}
