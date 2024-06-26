//
//  PetatetApp.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import SwiftUI

@main
struct PetatetApp: App {
  let container = DIContainer(appState: AppState(),
                              services: DIContainer.Services(APIService: RealAPIService(),
                                                             MediaLoader: BetterMediaLoader()))
    var body: some Scene {
        WindowGroup {
          ContentView(container: container)
            .accentColor(.orange)
        }
    }
}
