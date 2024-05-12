//
//  DIContainer.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation
import SwiftUI

struct DIContainer {
  let services: Services
  
  struct Services {
    let APIService: APIService
    let MediaLoader: MediaLoader
    
    static var stub: Self {
      .init(APIService: StubAPIService(),
            MediaLoader: StubMediaLoader())
    }
  }
  
  static var preview: Self {
    .init(services: .stub)
  }
}
