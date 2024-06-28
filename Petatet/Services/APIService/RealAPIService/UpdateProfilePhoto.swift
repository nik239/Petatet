//
//  UpdateProfilePhoto.swift
//  Petatet
//
//  Created by Nikita Ivanov on 28/06/2024.
//

import Foundation
import Alamofire

extension RealAPIService {
  func updateProfilePhoto(accessToken: String,
                          image: Data) async throws {
    let url = URLStringFor(endpoint: .updateProfilePhoto, withToken: accessToken)
    let params = ["server_key": serverKey]
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
    
    let upload = AF.upload(
      multipartFormData: { (multipartFormData) in
        for (key, value) in params {
          multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!,
                                   withName: key as String)
        }
        multipartFormData.append(image,
                                 withName: "avatar",
                                 fileName: "file.jpg",
                                 mimeType: "image/png")
      },
      to: url,
      usingThreshold: UInt64.init(),
      method: .post,
      headers: headers)
    
    let response = try await upload.serializingString().value
    print(response)
  }
}
