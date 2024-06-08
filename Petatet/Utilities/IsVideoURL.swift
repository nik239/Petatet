//
//  IsVideoURL.swift
//  Petatet
//
//  Created by Nikita Ivanov on 12/05/2024.
//

import Foundation

extension URL {
  func isVideoURL() -> Bool {
    switch self.pathExtension {
    case "mov", "mp4", "avi", "mkv":
      return true
    default:
      return false
    }
  }
}
