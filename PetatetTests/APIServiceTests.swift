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
  private var apiService = APIService()
  let username = "niki11081108@gmail.com"
  let password = "W14LoCPP"
  let token = "984370165166e874b086ace59c45a7e2173b539706b55575430a064e2379c922b0dad51688699875ad5ab36761669d6eadbaee691c4a1d22"
  
  func test_authenticate() async {
    let response = try! await apiService.authenticate(username: username, password: password)
  }
  
  func test_getFeed() async {
    let posts = try! await apiService.getPosts(accessToken: token, limit: 10, offSet: "")
    print(posts)
  }
}
