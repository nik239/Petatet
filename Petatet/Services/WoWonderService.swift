//
//  Networking.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import Foundation

struct WoWonderService {
  let baseURL = "https://petatet.org/api"
  
  func getInfo() async throws -> Data {
    guard let url = URL(string: baseURL + "get-site-settings") else {
      assertionFailure("URL() failed")
      throw "URL() failed"
    }
    
    let request = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: request)
    let statusCode = (response as? HTTPURLResponse)?.statusCode
    
    switch statusCode {
    case 200:
      return data
    default:
      throw "Server responded with error"
    }
  }
}
