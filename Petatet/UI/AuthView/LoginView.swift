//
//  LoginView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 10/05/2024.
//

import SwiftUI

private enum FocusableField {
  case email
  case password
}

struct LoginView: View {
  @ObservedObject var viewModel: AuthViewModel
  
  @FocusState private var focus: FocusableField?
  
  var body: some View {
    VStack {
//      Text("Login")
//        .font(.largeTitle)
//        .fontWeight(.bold)
//        .frame(maxWidth: .infinity, alignment: .leading)
      HStack {
        Image(systemName: "at")
        TextField("Username", text: $viewModel.email)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .focused($focus, equals: .email)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .password
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 4)
      
      HStack {
        Image(systemName: "lock")
        SecureField("Password", text: $viewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.go)
          .onSubmit {
            viewModel.signInWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
    }
    
    if !viewModel.errorMessage.isEmpty {
      VStack {
        Text(viewModel.errorMessage)
          .foregroundColor(Color(UIColor.systemRed))
      }
    }
    
    Button(action: viewModel.signInWithEmailPassword) {
      if viewModel.authState != .authenticating {
        Text("Login")
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
      }
      else {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .white))
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
      }
    }
    .disabled(!viewModel.isValid)
    .frame(maxWidth: .infinity)
    .buttonStyle(.borderedProminent)
    .accentColor(.orange)
    
    HStack {
      Text("Don't have an account yet?")
      Button(action: { viewModel.switchFlow() }) {
        Text("Sign up")
          .fontWeight(.semibold)
          .foregroundColor(.orange)
      }
    }
    .padding([.top, .bottom], 20)
  }
}

#if DEBUG
#Preview {
  LoginView(viewModel: AuthViewModel(container: .preview))
}
#endif
