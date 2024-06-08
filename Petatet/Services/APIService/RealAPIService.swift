//
//  Networking.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import Foundation
import Alamofire

struct RealAPIService: APIService {
  let serverKey = "3aca72d520a9dbee8ba5d0f34fd3436d"
  
  /// - Returns: AuthResponse
  func authenticate(username: String,
                    password: String)
  async throws -> AuthResponse? {
                      
    let url = URLStringFor(endpoint: .auth)
    
    let params = ["server_key": serverKey,
                  "username": username,
                  "password": password,
                  "ios_n_device_id":""]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingString().value
//                              .serializingDecodable(AuthResponse.self).value
    
    print(response)
    return nil
  }
  
  func getPosts(accessToken: String,
               limit: Int)
  async throws -> [Post]? {
    
    let url = URLStringFor(endpoint: .getFeed, withToken: accessToken)
    
    let params = ["server_key": serverKey,
                  "type": "get_news_feed",
                  "limit": limit] as [String : Any]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingDecodable(GetPostsResponse.self).value
//      .serializingString().value
    
//    print(response)
//    return nil
    return response.data
  }
  
}

extension RealAPIService {  
  func handleResponse<T>(_ data: Data, _ response: URLResponse,
                         completion: () throws -> T) throws -> T {
    
    let statusCode = (response as? HTTPURLResponse)?.statusCode
    
    switch statusCode {
    case 200:
      return try completion()
    case let errorCode:
      throw "Server responded with error: \(String(describing: errorCode))"
    }
  }
}
