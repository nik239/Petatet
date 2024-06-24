//
//  LikePost.swift
//  Petatet
//
//  Created by Nikita Ivanov on 24/06/2024.
//

import Foundation
import Alamofire

//MARK: - Like Post
extension RealAPIService {
  func likePost(accessToken: String,
                postId: String) async throws {
    let url = URLStringFor(endpoint: .likePost, withToken: accessToken)
    
    let params = ["server_key": serverKey,
                  "reaction": "2",
                  "action": "reaction",
                  "post_id": postId]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingString().value
    print(response)
  }
}
