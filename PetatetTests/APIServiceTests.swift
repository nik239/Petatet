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
  
  func test_authenticate() async {
      try? await apiService.authenticate(username: username,
                                         password: password)
  }
  
//  func test_getInfo() async {
//    do {
//      let siteInfo = try await apiService.getInfo()
//      print(siteInfo)
//    } catch {
//      XCTFail("\(error)")
//    }
//  }
//  
////  func test_sha256() async {
////    let service = APIService()
////    let sha256 = sha256(service.serverKey)
////  }
//  
//  func test_pureRequest() async {
//    do {
//      let response = try await apiService.pureRequest()
//      print(response)
//    } catch {
//      XCTFail("\(error)")
//    }
//  }
////  
//  func test_pureAlamo() async {
//    try! await apiService.pureAlamo()
//    try? await Task.sleep(nanoseconds: UInt64(3_000_000_000))
//  }
//  
//  func test_authenticate() async {
//    do {
//      let accessToken = try await apiService.authenticate(user: username, password: password)
//      print(accessToken)
//    } catch {
//      XCTFail("\(error)")
//    }
//  }
//  
//  func compareURLs() {
//    let baseUrl = "https://petatet.org/api/?type=auth"
//    let params = ["server_key": "somekey",
//                  "username":"niki11081108@gmail.com",
//                  "password":"W14LoCPP",
//                  "ios_n_device_id":""]
//    let alamo = AF.request(baseUrl, method: .post, parameters: params,
//                           encoding: URLEncoding.default, headers: nil)
//    print(alamo.url)
//    let foundation =
//  }
}
