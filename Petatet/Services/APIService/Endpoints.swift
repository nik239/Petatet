//
//  Endpoints.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/04/2024.
//

import Foundation

extension APIService {
  enum Endpoint: String {
    case auth = "auth"
    case getFeed = "posts"
  }
  
  func URLStringFor(endpoint: Endpoint, withToken token: String? = nil) -> String {
    
    var baseURL = "https://petatet.org/api/"
    baseURL += "?type=" + endpoint.rawValue
    if let token = token {
      baseURL += "&access_token=" + token
    }
    
    return baseURL
  }
}
