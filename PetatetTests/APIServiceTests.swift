//
//  WoWonderTests.swift
//  PetatetTests
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import XCTest
import Alamofire
@testable import Petatet

final class APIServiceTests: XCTestCase {
  private var apiService = RealAPIService()
  let username = "nivanov"
  let password = "W14LoCPP"
  let token = "984370165166e874b086ace59c45a7e2173b539706b55575430a064e2379c922b0dad51688699875ad5ab36761669d6eadbaee691c4a1d22"
  
  func test_authenticateSuccess() async {
    let response = try! await apiService.authenticate(username: username, password: password)
    switch response {
    case .success((let token, let uid)):
      print("Access token is: \(token)")
      print("User id is: \(uid)")
    case .failure:
      XCTFail()
    }
  }
  
  func test_authenticateFailure() async {
    let response = try! await apiService.authenticate(username: "", password: password)
    switch response {
    case .failure(let error):
      print("Error is: \(error)")
    case .success:
      XCTFail()
    }
  }
  
  func test_createAccountSuccess() async {
    let response = try! await apiService.createAccount(username: "tester2",
                                                       password: "TesterTester*",
                                                       email: "testertester2@gmail.com",
                                                       confirmPassword: "TesterTester*")
    switch response {
    case .success:
      return
    case .failure:
      XCTFail()
    }
  }
  
  func test_createAccountFailure() async {
    let response = try! await apiService.createAccount(username: "tester",
                                                       password: "TesterTester*",
                                                       email: "testertester@gmail.com",
                                                       confirmPassword: "Tester*")
    switch response {
    case .success:
      XCTFail()
    case .failure(let error):
      print(error)
    }
  }
  
  func test_getFeed() async {
    let posts = try? await apiService.getFeed(accessToken: token, limit: 10, afterPostID: nil)
//    print(posts!.count)
//    posts?.forEach { post in
//      print(post)
//    }
  }
  
  func test_getAnimals() async {
    let posts = try? await apiService.getAnimalsForAdoption(accessToken: token,
                                                            limit: 10,
                                                            afterPostID: nil,
                                                            getCats: true)
//    print(posts!.count)
//    posts?.forEach { post in
//      print(post)
//    }
  }
  
  func test_getUserPosts() async {
    let posts = try? await apiService.getUserPosts(accessToken: token,
                                                            limit: 10,
                                                            afterPostID: nil,
                                                            uid: "18836")
  }
  
  func test_newPost() async {
    try! await apiService.newPost(accessToken: token,
                                  userID: "18836",
                                  postText: "test3")
  }
  
  func test_newPostImageUpload() async {
    let imageURL = Bundle.main.url(forResource: "avatar", withExtension: "jpg")!
    let imageURL2 = Bundle.main.url(forResource: "Dog", withExtension: "jpg")!
    let imageData = try! Data(contentsOf: imageURL)
    let imageData2 = try! Data(contentsOf: imageURL2)
    let images = [imageData]
    
    try! await apiService.newPost(accessToken: token,
                                  userID: "18836",
                                  postText: "test",
                                  images: images)
  }
  
  func test_newPostVideoUpload() async {
    let videoURL = Bundle.main.url(forResource: "DogMovie", withExtension: "mov")!
    let videoData = try! Data(contentsOf: videoURL)
    
    try! await apiService.newPost(accessToken: token,
                                 userID: "18836",
                                 postText: "test",
                                 video: videoData)
  }
  
  func test_getUserData() async {
    let response = try! await apiService.getUserData(accessToken: token, uid: "18011")
    switch response{
    case .success(let profile):
      print(profile.isFollowing!)
    case .failure:
      XCTFail()
    }
  }
  
  func test_followUser() async {
    try! await apiService.followUser(accessToken: token, uid: "18011")
  }
  
  func test_updateProfilePhoto() async {
    try! await apiService.updateProfilePhoto(accessToken: token, image: Data())
  }
  
//  func test_getImage() async {
//    let loader = ImageLoader()
//    let image = try? await loader.image("https://petatet.org/upload/photos/2024/05/IZgBkkS77f21BZFR2nPH_01_425d5a609da74caee2293c0283b98d39_image.jpg")
//    print(image)
//  }
}
