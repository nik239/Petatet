//
//  NewPost.swift
//  Petatet
//
//  Created by Nikita Ivanov on 24/06/2024.
//

import Foundation
import Alamofire

// MARK: - Upload new Post
extension RealAPIService {
  func newPost(accessToken: String,
               userID: String,
               postText: String,
               images: [Data]? = nil,
               video: Data? = nil,
               progressHandler: ((Progress) -> Void)? = nil)
  
  async throws {
    let url = URLStringFor(endpoint: .newPost, withToken: accessToken)
    var params = ["server_key": serverKey,
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
      try await uploadImages(url: url,
                             params: params,
                             images: images,
                             progressHandler: progressHandler)
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
    
    func uploadImages(url: String,
                      params: [String: Any],
                      images: [Data],
                      progressHandler: ((Progress) -> Void)? = nil) async throws {
      let upload = AF.upload(
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
      
      
      upload.uploadProgress { progress in
        progressHandler?(progress)
      }
      
      let response = try await upload.serializingString().value
//      .serializingString().value
//
//      print(response)
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
