//
//  BetterMediaLoader.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation
import UIKit
import AVFoundation

actor BetterMediaLoader: MediaLoader {
  
  enum DownloadState {
    case inProgress(Task<Media, Error>)
    case completed(Media)
    case failed
  }
  
  private(set) var downloadCache = Cache<URL, DownloadState>()
  
  func file(_ url: URL) async throws -> Media {
    if let cached = downloadCache[url] {
      switch cached {
      case .completed(let media):
        return media
      case .inProgress(let task):
        return try await task.value
      case .failed: throw "Download failed"
      }
    }

    let download: Task<Media , Error> = Task.detached {
      //print("Download: \(url.absoluteString)")
      return try await self.downloadFile(from: url)
    }

    downloadCache[url] = .inProgress(download)

    do {
      let result = try await download.value
      downloadCache[url] = .completed(result)
      return result
    } catch {
      downloadCache[url] = .failed
      throw error
    }
  }
  
  func downloadFile(from url: URL) async throws -> Media {
    if !url.isVideoURL() {
      let data = try await URLSession.shared.data(from: url).0
      let image = UIImage(data: data)!
      return Media.photo(image)
    } else {
      let videoAsset = AVAsset(url: url)
      _ = try await videoAsset.load(.tracks,
                                    .duration,
                                    .isPlayable,
                                    .isExportable,
                                    .isReadable)
      return Media.video(videoAsset)
    }
  }
}
