//
//  VideoLoader.swift
//  Petatet
//
//  Created by Nikita Ivanov on 04/05/2024.
//

//import Foundation
//import Alamofire
//import UIKit
//
//actor RealMediaLoader: ObservableObject, MediaLoader {
//  enum DownloadState {
//    case inProgress(Task<URL, Error>)
//    case completed(URL)
//    case failed
//  }
//  
//  private(set) var cache: [URL: DownloadState] = [:]
//  
//  func add(_ url: URL, forKey key: URL) {
//    cache[key] = .completed(url)
//  }
//  
//  func file(_ serverPath: URL) async throws -> URL {
//    if let cached = cache[serverPath] {
//      switch cached {
//      case .completed(let url):
//        return url
//      case .inProgress(let task):
//        return try await task.value
//      case .failed: throw "Download failed"
//      }
//    }
//
//    let download: Task<URL, Error> = Task.detached {
//      print("Download: \(serverPath.absoluteString)")
//      return try await self.downloadFile(from: serverPath)
//    }
//
//    cache[serverPath] = .inProgress(download)
//
//    do {
//      let result = try await download.value
//      add(result, forKey: serverPath)
//      return result
//    } catch {
//      cache[serverPath] = .failed
//      throw error
//    }
//  }
//  
//  func downloadFile(from url: URL) async throws -> URL {
//    let diskURL = try await withCheckedThrowingContinuation { continuation in
//      AF.download(url).responseURL { response in
//        switch response.result {
//        case .success(let fileURL):
//          continuation.resume(returning: fileURL)
//        case .failure(let error):
//          continuation.resume(throwing: error)
//        }
//      }
//    }
//    return diskURL
//  }
//}
