//
//  FollowUser.swift
//  Petatet
//
//  Created by Nikita Ivanov on 27/06/2024.
//

import Alamofire

extension RealAPIService {
  //Note: If more than 50 posts are requested, the API will only return 20.
  func followUser(accessToken: String,
                  uid: String)
  async throws {
    let url = URLStringFor(endpoint: .followUser, withToken: accessToken)
    let params = ["server_key": serverKey,
                  "user_id": uid] as [String : Any]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingString().value
    
    print(response)
  }
}
