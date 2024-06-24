//
//  AuthViewModel.swift
//  Petatet
//
//  Created by Nikita Ivanov on 10/05/2024.
//

import Foundation

enum AuthFlow {
  case login
  case signup
}

enum AuthState {
  case unauthenticated
  case authenticating
  case authenticated
}

@MainActor 
final class AuthViewModel: ObservableObject {
  @Published var authState: AuthState = .unauthenticated
  @Published var flow: AuthFlow = .login
  
  @Published var username = ""
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""
  
  @Published var isValid = false
  @Published var errorMessage = ""
  
  private let APIService: APIService
  
  init(container: DIContainer) {
    self.APIService = container.services.APIService
    makeIsValidPublisher()
  }
  
  func signInWithEmailPassword() {
    authState = .authenticating
    Task {
      let response = try await APIService.authenticate(username: email,
                                                        password: password)
      
      switch response {
      case .success((let token, let uid)):
        //save token and uid
        self.authState = .authenticated
      case .failure(let error):
        self.errorMessage = error
        authState = .unauthenticated
      }
    }
  }
  
  func signUpWithEmailPassword() {
    authState = .authenticating
    Task {
      let response = try await APIService.createAccount(username: username,
                                                        password: password,
                                                        email: email,
                                                        confirmPassword: confirmPassword)
      switch response {
      case .success:
        self.errorMessage = "Registration successful! Please check your inbox to verify your email!"
      case .failure(let error):
        self.errorMessage = error
      }
      authState = .unauthenticated
    }
  }
  
  private func makeIsValidPublisher() {
    //AuthViewModel is not responsible for checking that the passwords match
    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
        ? !(email.isEmpty || password.isEmpty)
        : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)
  }
  
  func switchFlow() {
    flow = flow == .login ? .signup : .login
    errorMessage = ""
  }
}
