//
//  WoWonderTests.swift
//  PetatetTests
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import XCTest
@testable import Petatet

final class APIServiceTests: XCTestCase {
  private var apiService = APIService()
  let username = "niki11081108@gmail.com"
  let password = "W14LoCPP"
  
  func test_getInfo() async {
    do {
      let siteInfo = try await apiService.getInfo()
      print(siteInfo)
    } catch {
      XCTFail("\(error)")
    }
  }
  
  func test_authenticate() async {
    do {
      let accessToken = try await apiService.authenticate(user: username, password: password)
      print(accessToken)
    } catch {
      XCTFail("\(error)")
    }
  }
}
