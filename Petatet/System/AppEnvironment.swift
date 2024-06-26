//
//  AppEnvironment.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import Foundation

struct AppEnvironment {
  let container: DIContainer
}

extension AppEnvironment {
  static func bootstrap() -> AppEnvironment {
    return AppEnvironment(container:
           DIContainer(appState: AppState(),
                       services: DIContainer.Services(APIService: RealAPIService(),
                                MediaLoader: BetterMediaLoader())))
  }
}
