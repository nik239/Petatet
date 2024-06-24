//
//  SignUpView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 10/05/2024.
//

import SwiftUI

private enum FocusableField {
  case email
  case password
  case confirmPassword
}

struct SignupView: View {
  @ObservedObject var viewModel: AuthViewModel

  @FocusState private var focus: FocusableField?
  
  var body: some View {
    VStack {
//      Text("Sign up")
//        .font(.largeTitle)
//        .fontWeight(.bold)
//        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack {
        Image(systemName: "at")
          .padding(.leading, 4)
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
        Image(systemName: "envelope.circle")
          .padding(.leading, 4)
        TextField("Email", text: $viewModel.email)
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
          .padding(.leading, 4)
        SecureField("Password", text: $viewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .confirmPassword
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
      
      HStack {
        Image(systemName: "lock")
          .padding(.leading, 4)
        SecureField("Confirm password", text: $viewModel.confirmPassword)
          .focused($focus, equals: .confirmPassword)
          .submitLabel(.go)
          .onSubmit {
            viewModel.signUpWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
      
      if !viewModel.errorMessage.isEmpty {
        VStack {
          Text(viewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }

      Button(action: viewModel.signUpWithEmailPassword) {
        if viewModel.authState != .authenticating {
          Text("Sign up")
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .accentColor(.orange)
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
        Text("Already have an account?")
        Button(action: { viewModel.switchFlow() }) {
          Text("Log in")
            .fontWeight(.semibold)
            .foregroundColor(.orange)
        }
      }
      .padding([.top, .bottom], 20)
    }
  }
}

#if DEBUG
#Preview {
  SignupView(viewModel: AuthViewModel(container: .preview))
}
#endif
