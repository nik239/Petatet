//
//  AuthView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 10/05/2024.
//

import SwiftUI

struct AuthView <Content: View>: View {
  @ObservedObject var viewModel: AuthViewModel
  @ViewBuilder var content: () -> Content
  var body: some View {
    switch viewModel.authState {
    case .unauthenticated, .authenticating:
      VStack {
        Image("PetatetLogo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: UIScreen.main.bounds.width * 0.5)
        switch viewModel.flow {
        case .login:
          LoginView(viewModel: viewModel)
            .padding()
        case .signup:
          SignupView(viewModel: viewModel)
            .padding()
        }
      }
    case .authenticated:
      content()
    }
  }
}

#Preview {
  AuthView(viewModel: AuthViewModel(container: .preview)) {
    BottomNavigationView(container: .preview)
  }
}
