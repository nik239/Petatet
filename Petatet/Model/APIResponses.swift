//
//  APIResponses.swift
//  Petatet
//
//  Created by Nikita Ivanov on 08/04/2024.
//

struct AuthResponse: Decodable {
  let api_status: Int
  let access_token: String
  let user_id: String
  let timezone: String
}

struct GetPostsResponse: Decodable {
  let api_status: Int
  let data: [Post]
}

