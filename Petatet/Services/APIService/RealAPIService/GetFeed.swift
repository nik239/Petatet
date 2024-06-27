//
//  GetFeed.swift
//  Petatet
//
//  Created by Nikita Ivanov on 24/06/2024.
//

import Alamofire

extension RealAPIService {
  //Note: If more than 50 posts are requested, the API will only return 20.
  func getFeed(accessToken: String,
                limit: Int,
                afterPostID: String?)
  async throws -> [Post]? {
    let url = URLStringFor(endpoint: .getFeed, withToken: accessToken)
    let afterPostID = afterPostID ?? ""
    let params = ["server_key": serverKey,
                  "type": "get_news_feed",
                  "limit": limit,
                  "after_post_id": afterPostID] as [String : Any]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingDecodable(GetFeedResponse.self).value
    //      .serializingString().value
    //
    //    print(response)
    //    return nil
    return response.data
  }
  
  func getAnimalsForAdoption(accessToken: String,
                             limit: Int,
                             afterPostID: String?,
                             getCats: Bool)
  async throws -> [Post]? {
    let url = URLStringFor(endpoint: .getFeed, withToken: accessToken)
    let afterPostID = afterPostID ?? ""
    let hashtag = getCats ? "CatForAdoption" : "DogForAdoption"
    let params = ["server_key": serverKey,
                  "type": "hashtag",
                  "limit": limit,
                  "hash": hashtag,
                  "after_post_id": afterPostID] as [String : Any]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingDecodable(GetFeedResponse.self).value
//          .serializingString().value
//    
//        print(response)
//        return nil
    return response.data
  }
  
  func getUserPosts(accessToken: String,
                    limit: Int,
                    afterPostID: String?,
                    uid: String)
  async throws -> [Post]? {
    let url = URLStringFor(endpoint: .getFeed, withToken: accessToken)
    let afterPostID = afterPostID ?? ""
    let params = ["server_key": serverKey,
                  "type": "get_user_posts",
                  "limit": limit,
                  "id": uid,
                  "after_post_id": afterPostID] as [String : Any]
    
    let response = try await AF.request(url,
                                        method: .post,
                                        parameters: params,
                                        encoding: URLEncoding.default,
                                        headers: nil)
      .serializingDecodable(GetFeedResponse.self).value
//          .serializingString().value
//    
//        print(response)
//        return nil
    return response.data
  }
}

struct GetFeedResponse: Decodable {
  let api_status: Int
  let data: [Post]
}
