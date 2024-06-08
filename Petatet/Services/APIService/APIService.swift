//
//  APIService.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation

protocol APIService {
  func authenticate(username: String, password: String) async throws
  -> AuthResponse?
  
  func getPosts(accessToken: String, limit: Int) async throws
  -> [Post]?
}

struct StubAPIService: APIService {
  func authenticate(username: String, password: String) async throws 
  -> AuthResponse? {
    return AuthResponse(api_status: 200,
                        access_token: "token",
                        user_id: "1",
                        timezone: "EDT")
  }
  
  func getPosts(accessToken: String, limit: Int) async throws 
  -> [Post]? {
    return PreviewPosts().posts
  }
}

