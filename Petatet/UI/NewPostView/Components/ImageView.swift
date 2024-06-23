//
//  PhotosView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 22/06/2024.
//

import SwiftUI

struct ImageView: View {
  var image: UIImage?
//  init(imageData: Data) {
//    self.image = UIImage(data: imageData)
//  }
  var body: some View {
    if image != nil {
      Image(uiImage: image!)
        .resizable()
        .aspectRatio(contentMode: .fill)
    } else {
      Image(systemName: "camera.metering.unknown")
        .resizable()
        .aspectRatio(contentMode: .fill)
    }
  }
}

//#Preview {
//    ImageView()
//}
