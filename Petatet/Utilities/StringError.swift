//
//  StringError.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import Foundation

extension String: LocalizedError {
  
  public var errorDescription: String? {
    return self
  }
}
