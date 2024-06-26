//
//  DIContainer.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation
import SwiftUI

struct DIContainer {
  let appState: AppState
  let services: Services
  
  struct Services {
    let APIService: APIService
    let MediaLoader: MediaLoader
    
    static var stub: Self {
      .init(APIService: StubAPIService(),
            MediaLoader: StubMediaLoader())
    }
  }
  #if DEBUG
  static var preview: Self {
    .init(appState: AppState.preview, services: .stub)
  }
  #endif
}
