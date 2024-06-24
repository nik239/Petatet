//
//  ContentView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/03/2024.
//

import SwiftUI

struct ContentView: View {
  let container: DIContainer
  var body: some View {
    VStack {
      AuthView(viewModel: AuthViewModel(container: container)) {
        BottomNavigationView(container: container)
      }
    }
  }
}

#Preview {
  ContentView(container: .preview)
}
