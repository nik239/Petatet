//
//  AppState.swift
//  Petatet
//
//  Created by Nikita Ivanov on 25/06/2024.
//

import Foundation

final class AppState: ObservableObject {
  @Published private (set) var authState: AuthState
  
  private(set) var uid: String {
    get { userDefaults[.uid] ?? "" }
    set { userDefaults[.uid] = newValue }
  }
  
  private(set) var token: String {
    get { userDefaults[.token] ?? "" }
    set { userDefaults[.token] = newValue }
  }
  
  let userDefaults: UserDefaults
  
  init() {
    self.userDefaults = .standard
    guard let uid = userDefaults[.uid],
          let token = userDefaults[.token] else {
      self.authState = .unauthenticated
      return
    }
    if uid != "" && token != "" {
      self.authState = .authenticated
    } else {
      self.authState = .unauthenticated
    }
    return
  }
  
  func logIn(token: String, uid: String) {
    self.token = token
    self.uid = uid
    self.authState = .authenticated
  }
  
  func logOut(){
    self.uid = ""
    self.token = ""
    self.authState = .unauthenticated
  }
  
  private init(authState: AuthState) {
    self.authState = authState
    self.userDefaults = .standard
    self.uid = "nivanov"
    self.token = "984370165166e874b086ace59c45a7e2173b539706b55575430a064e2379c922b0dad51688699875ad5ab36761669d6eadbaee691c4a1d22"
  }
}

//MARK: - Preview
extension AppState {
  static var preview = AppState(authState: .authenticated)
}

