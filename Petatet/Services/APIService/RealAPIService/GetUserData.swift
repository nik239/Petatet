//
//  GetUserData.swift
//  Petatet
//
//  Created by Nikita Ivanov on 27/06/2024.
//

import Alamofire

extension RealAPIService {
  //Note: If more than 50 posts are requested, the API will only return 20.
  func getUserData(accessToken: String,
                   uid: String)
  async throws -> UserDataResponse {
    let url = URLStringFor(endpoint: .userData, withToken: accessToken)
    let params = ["server_key": serverKey,
                  "user_id": uid,
                  "fetch": "user_data"] as [String : Any]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingDecodable(UserDataResponse.self).value
//          .serializingString().value
//
//        print(response)
//        return nil
    return response
  }
}

enum UserDataResponse {
  case success(Profile)
  case failure
}

extension UserDataResponse: Decodable {
  enum CodingKeys: String, CodingKey {
    case api_status, user_data
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      let apiStatus = try container.decode(Int.self, forKey: .api_status)
      if apiStatus == 200 {
        let userData = try container.decode(Profile.self, forKey: .user_data)
        self = .success(userData)
      } else {
        self = .failure
      }
    } catch {
      let apiStatus = try container.decode(String.self, forKey: .api_status)
      if apiStatus == "200" {
        let userData = try container.decode(Profile.self, forKey: .user_data)
        self = .success(userData)
      } else {
        self = .failure
      }
    }
  }
}
