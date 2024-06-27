//
//  APIService.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation

protocol APIService {
  func authenticate(username: String, password: String) async throws
  -> AuthResponse
  
  func createAccount(username: String,
                     password: String,
                     email: String,
                     confirmPassword: String)
  async throws -> CreateAccountResponse
  
  func getFeed(accessToken: String,
                limit: Int,
                afterPostID: String?) async throws
  -> [Post]?
  
  func getAnimalsForAdoption(accessToken: String,
                             limit: Int,
                             afterPostID: String?,
                             getCats: Bool)
  async throws -> [Post]?
  
  func getUserPosts(accessToken: String,
                    limit: Int,
                    afterPostID: String?,
                    uid: String)
  async throws -> [Post]?
  
  func newPost(accessToken: String,
               userID: String,
               postText: String,
               images: [Data]?,
               video: Data?)
  async throws
  
  func likePost(accessToken: String,
                postId: String)
  async throws
  
  func getUserData(accessToken: String,
                   uid: String)
  async throws -> UserDataResponse
  
}

struct StubAPIService: APIService {
  func getUserData(accessToken: String, uid: String) async throws -> UserDataResponse {
    .success(Profile(uid: "guest",
                     username: "Ace",
                     name: Profile.Name(first: "Ace",last: "Ventura"),
                     avatar: LocalFiles.avatar))
  }
  
  func getAnimalsForAdoption(accessToken: String, limit: Int, afterPostID: String?, getCats: Bool)
  async throws -> [Post]? {
    return PreviewPosts().posts
  }
  
  func getUserPosts(accessToken: String, limit: Int, afterPostID: String?, uid: String)
  async throws -> [Post]? {
    return PreviewPosts().posts
  }
  
  func createAccount(username: String,
                     password: String,
                     email: String,
                     confirmPassword: String) async throws -> CreateAccountResponse {
    return CreateAccountResponse.success
  }
  
  func likePost(accessToken: String, postId: String) async throws {}
  
  func authenticate(username: String, password: String) async throws 
  -> AuthResponse {
    return AuthResponse.success(("token", "uid"))
  }
  
  func getFeed(accessToken: String,
                limit: Int,
                afterPostID: String?) async throws
  -> [Post]? {
    return PreviewPosts().posts
  }
  
  func newPost(accessToken: String,
               userID: String,
               postText: String,
               images: [Data]? = nil,
               video: Data? = nil)
  
  async throws {}
}

