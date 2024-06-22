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
  
  //Note: If more than 50 posts are requested, the API will only return 20.
  func getPosts(accessToken: String,
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
      .serializingDecodable(GetPostsResponse.self).value
    //      .serializingString().value
    //
    //    print(response)
    //    return nil
    return response.data
  }
}

// MARK: - Upload new Post
extension RealAPIService {
  func newPost(accessToken: String,
               userID: String,
               postText: String,
               images: [Data]? = nil,
               video: Data? = nil)
  
  async throws {
    let url = URLStringFor(endpoint: .newPost, withToken: accessToken)
    let params = ["server_key": serverKey,
             "user_id": userID,
             "s": accessToken,
             "postText": postText,
             "post_color": "0",
              "postPrivacy": 0] as [String: Any]
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
    
    switch (images, video) {
    case (nil, nil):
      try await uploadTextPost(url: url, params: params)
    case let (images?, nil):
      try await uploadImages(url: url, params: params, images: images)
    case let (nil, video?):
      try await uploadVideo(url: url, params: params, video: video)
    default:
      throw "A post can't contain both images and video!"
    }
    
    func uploadTextPost(url: String, params: [String: Any]) async throws {
      let response = try await AF.request(url,
                                          method: .post,
                                          parameters: params,
                                          encoding: URLEncoding.default,
                                          headers: nil)
        .serializingString().value
      
      print(response)
    }
    
    func uploadImages(url: String, params: [String: Any], images: [Data]) async throws {
      let response = try await
      AF.upload(
        multipartFormData: { (multipartFormData) in
          for (key, value) in params {
            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!,
                                     withName: key as String)
          }
          for data in images{
            multipartFormData.append(data,
                                     withName: "postPhotos[]",
                                     fileName: "file.jpg",
                                     mimeType: "image/png")
          }
        },
        to: url,
        usingThreshold: UInt64.init(),
        method: .post,
        headers: headers)
      .serializingString().value
      
      print(response)
    }
    
    func uploadVideo(url: String, params: [String: Any], video: Data) async throws {
      let response = try await
      AF.upload(
        multipartFormData: { (multipartFormData) in
          for (key, value) in params {
            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!,
                                     withName: key as String)
          }
          multipartFormData.append(video,
                                   withName: "postVideo",
                                   fileName: "video.mp4",
                                   mimeType: "video/mp4")
        },
        to: url,
        usingThreshold: UInt64.init(),
        method: .post,
        headers: headers)
      .serializingString().value
      
      print(response)
    }
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
