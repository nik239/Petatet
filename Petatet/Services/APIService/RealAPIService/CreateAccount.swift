//
//  CreateAccount.swift
//  Petatet
//
//  Created by Nikita Ivanov on 24/06/2024.
//

import Alamofire

//MARK: -Create Account
extension RealAPIService {
  func createAccount(username: String,
                     password: String,
                     email: String,
                     confirmPassword: String)
  async throws -> CreateAccountResponse {
    let url = URLStringFor(endpoint: .createAccount)
    let params = ["server_key": serverKey,
                  "username": username,
                  "password": password,
                  "email": email,
                  "confirm_password": confirmPassword,
                  "ios_n_device_id": ""]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingDecodable(CreateAccountResponse.self).value
    
    return response
  }
}

enum CreateAccountResponse {
  case success
  case failure(String)
}

extension CreateAccountResponse: Decodable {
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
      if apiStatus == 220 {
        self = .success
      } else {
        let error = try container.decode(Error.self, forKey: .errors)
        self = .failure(error.error_text)
      }
    } catch {
      let apiStatus = try container.decode(String.self, forKey: .api_status)
      if apiStatus == "220" {
        self = .success
      } else {
        let error = try container.decode(Error.self, forKey: .errors)
        self = .failure(error.error_text)
      }
    }
  }
}
