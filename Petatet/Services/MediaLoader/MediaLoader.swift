//
//  MediaLoader.swift
//  Petatet
//
//  Created by Nikita Ivanov on 08/05/2024.
//

import Foundation
import AVFoundation
import UIKit

protocol MediaLoader {
  func file(_ url: URL) async throws -> Media
}

struct StubMediaLoader: MediaLoader {
  func file(_ url: URL) -> Media {
    if url.isVideoURL() {
      return Media.video(AVAsset(url: url))
    } else {
      let image = UIImage(contentsOfFile: url.path)!
      return Media.photo(image)
    }
  }
}

