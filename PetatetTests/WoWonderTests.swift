//
//  WoWonderTests.swift
//  PetatetTests
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import XCTest
@testable import Petatet

final class GetInfoTest: XCTestCase {
  private var wwService = WoWonderService()
  
  func testGetInfo() async {
    do {
      let siteInfo = try await wwService.getInfo()
      print(siteInfo)
    } catch {
      XCTFail("\(error)")
    }
  }
}
