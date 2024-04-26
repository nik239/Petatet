//
//  Networking.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import Foundation
import Alamofire

struct APIService {
  let baseURL = "https://petatet.org/api/"
  let serverKey = "3aca72d520a9dbee8ba5d0f34fd3436d"
  let appID = "c19e82c6e9e9620810b8db5c5a7d50b3"
  
//  func pureRequest() async throws -> [String: Any]? {
//    var baseUrl = "https://petatet.org/api/?type=auth"
//    let parameters: [String: String] = ["server_key":serverKey,
//                                        "username":"niki11081108@gmail.com",
//                                        "password":"W14LoCPP",
//                                        "ios_n_device_id":""]
//    //    var components = URLComponents(string: baseURL)
//    //    components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//    //    let url = components!.url!
//    //    print(url)
//    var request = try URLRequest(url: baseUrl, method: .post, headers: nil)
//    try parameters.map { try URLEncoding.default.encode($0, into: request) }
//    let params = try URLEncoding.default.encode(request, with: parameters)
//    
//    let (data, response) = try await URLSession.shared.data(for: request)
//    let infoJSON = try handleResponse(data, response) {
//      let json = try JSONSerialization.jsonObject(with: data)
//      let dict = json as? [String: Any]
//      return dict
//    }
//    
//    return infoJSON
//  }
  
  /// - Returns: API access token
  func authenticate(username: String, password: String) async throws {
    let params = ["server_key": serverKey,
                  "username":username,
                  "password":password,
                  "ios_n_device_id":""]
    
    let respons1 = await AF.request("someurl", interceptor: .retryPolicy).response
    
    let response = await AF.request(baseURL,
                                    method: .post,
                                    parameters: params,
                                    encoding: URLEncoding.default,
                                    headers: nil)
      .serializingDecodable([String:String].self)
      .response
    
    print(response)
  }
  
  func pureAlamo() async throws {
    let baseUrl = "https://petatet.org/api/?type=auth"
    let params = ["server_key":serverKey,
                  "username":"niki11081108@gmail.com",
                  "password":"W14LoCPP",
                  "ios_n_device_id":""]
    AF.request(baseUrl, method: .post, parameters: params,
               encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
      let json = try! handleResponse(response.data!, response.response!) {
        let json = try! JSONSerialization.jsonObject(with: response.data!)
        let dict = json as? [String: Any]
        print(dict)
      }
    }
  }
  
//  / - Returns: API access token
//  func authenticate(username: String, password: String) async throws -> String? {
//    
//    var request = try requestFor(endpoint: "")
//    request.httpMethod = "POST"
//    //request.setValue(serverKey, forHTTPHeaderField: "server_key")
//    //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    let credentials = ["server_key":serverKey,
//                       "application":appID]
//    request.httpBody = try JSONSerialization.data(withJSONObject: credentials)
//    
//    let (data, response) = try await URLSession.shared.data(for: request)
//    
//    let accessToken = try handleResponse(data, response) {
//      let json = try JSONSerialization.jsonObject(with: data)
//      let dict = json as? [String: Any]
//      print(dict)
//      
//      //      let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
//      //      return authResponse.access_token
//    }
//    
//    //return accessToken
//    return nil
//  }
}

extension APIService {
  func requestFor(endpoint: String) throws -> URLRequest {
    
    guard let url = URL(string: baseURL + endpoint) else {
      throw "URL(string:) returned nil"
    }
    return URLRequest(url: url)
  }
  
//  func encodeWithURLEncoding(parameters: [String: String]) -> URLRequest {
//    var urlRequest = try urlRequest.asURLRequest()
//    guard let parameters else { return urlRequest }
//    
//    if let method = urlRequest.method, destination.encodesParametersInURL(for: method) {
//      guard let url = urlRequest.url else {
//        throw AFError.parameterEncodingFailed(reason: .missingURL)
//      }
//      
//      if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
//        let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
//        urlComponents.percentEncodedQuery = percentEncodedQuery
//        urlRequest.url = urlComponents.url
//      }
//    } else {
//      if urlRequest.headers["Content-Type"] == nil {
//        urlRequest.headers.update(.contentType("application/x-www-form-urlencoded; charset=utf-8"))
//      }
//      
//      urlRequest.httpBody = Data(query(parameters).utf8)
//    }
//    
//    return urlRequest
//  }
//  
//  private func query(_ parameters: [String: Any]) -> String {
//      var components: [(String, String)] = []
//
//      for key in parameters.keys.sorted(by: <) {
//          let value = parameters[key]!
//          components += queryComponents(fromKey: key, value: value)
//      }
//      return components.map { "\($0)=\($1)" }.joined(separator: "&")
//  }
  
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
