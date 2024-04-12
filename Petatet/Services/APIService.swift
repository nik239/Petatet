//
//  Networking.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import Foundation

struct APIService {
  let baseURL = "https://petatet.org/api/get-site-settings"
  let serverKey = "3aca72d520a9dbee8ba5d0f34fd3436d"
  
  func getInfo() async throws -> [String: Any]? {
    
    var request = try requestFor(endpoint: "get-site-settings")
    //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let credentials = ["server_key": serverKey]
    request.httpBody = try JSONSerialization.data(withJSONObject: credentials)
    let (data, response) = try await URLSession.shared.data(for: request)
    let infoJSON = try handleResponse(data, response) {
      let json = try JSONSerialization.jsonObject(with: data)
      let dict = json as? [String: Any]
      return dict
    }
    
    return infoJSON
  }
  
  /// - Returns: API access token
  func authenticate(user: String, password: String) async throws -> String? {
    
    var request = try requestFor(endpoint: "auth")
    request.httpMethod = "POST"
    //request.setValue(serverKey, forHTTPHeaderField: "server_key")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let credentials = ["server_key": serverKey]
    request.httpBody = try JSONSerialization.data(withJSONObject: credentials)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    let accessToken = try handleResponse(data, response) {
      let json = try JSONSerialization.jsonObject(with: data)
      let dict = json as? [String: Any]
      print(dict)
      
//      let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
//      return authResponse.access_token
    }
    
    //return accessToken
    return nil
  }
}

extension APIService {
  func requestFor(endpoint: String) throws -> URLRequest {
    
    guard let url = URL(string: baseURL) else {
      throw "URL(string:) returned nil"
    }
    return URLRequest(url: url)
  }
  
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
