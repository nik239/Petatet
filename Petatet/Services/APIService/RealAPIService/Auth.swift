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
  async throws -> AuthResponse {
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
      //.serializingString().value
      .serializingDecodable(AuthResponse.self).value
  
    //print(response)
    return response
  }
}

enum AuthResponse {
  case success((String, String))
  case failure(String)
}

extension AuthResponse: Decodable {
  enum CodingKeys: String, CodingKey {
    case api_status, access_token, user_id, errors
  }
  
  struct Error: Decodable {
    let error_text: String
  }
  
  // API may return status as number or string based on the response
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      let apiStatus = try container.decode(Int.self, forKey: .api_status)
      if apiStatus == 200 {
        let userID = try container.decode(String.self, forKey: .user_id)
        let accessToken = try container.decode(String.self, forKey: .access_token)
        self = .success((accessToken, userID))
      } else {
        let error = try container.decode(Error.self, forKey: .errors)
        self = .failure(error.error_text)
      }
    } catch {
      let apiStatus = try container.decode(String.self, forKey: .api_status)
      if apiStatus == "200" {
        let userID = try container.decode(String.self, forKey: .user_id)
        let accessToken = try container.decode(String.self, forKey: .access_token)
        self = .success((accessToken, userID))
      } else {
        let error = try container.decode(Error.self, forKey: .errors)
        self = .failure(error.error_text)
      }
    }
  }
}



