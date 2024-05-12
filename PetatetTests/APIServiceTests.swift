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
  
  func test_authenticate() async {
    let response = try! await apiService.authenticate(username: username, password: password)
  }
  
  func test_getFeed() async {
    let posts = try! await apiService.getPosts(accessToken: token, limit: 50, offSet: "")
//    posts?.forEach { post in
//      print(post)
//    }
  }
  
//  func test_getImage() async {
//    let loader = ImageLoader()
//    let image = try? await loader.image("https://petatet.org/upload/photos/2024/05/IZgBkkS77f21BZFR2nPH_01_425d5a609da74caee2293c0283b98d39_image.jpg")
//    print(image)
//  }
}
