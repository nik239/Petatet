//
//  Sha22.swift
//  Petatet
//
//  Created by Nikita Ivanov on 13/04/2024.
//

import Foundation
import CryptoKit


func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()

  return hashString
}

