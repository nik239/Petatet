//
//  ProfileViewModel.swift
//  Petatet
//
//  Created by Nikita Ivanov on 27/06/2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
  let container: DIContainer
  let apiService: APIService
  let appState: AppState
  let mediLoader: MediaLoader
  
  var uid: String
  @Published var profile: Profile?
  lazy var isSelf: Bool = {uid == appState.uid}()
  
  init(container: DIContainer, uid: String?) {
    self.container = container
    self.appState = container.appState
    self.apiService = container.services.APIService
    self.mediLoader = container.services.MediaLoader
    if let uid = uid {
      self.uid = uid
    } else {
      self.uid = appState.uid
    }
    Task {
      try await getProfile(for: self.uid)
    }
  }
  
  init() {
    self.container = .preview
    self.appState = container.appState
    self.apiService = container.services.APIService
    self.mediLoader = container.services.MediaLoader
    self.uid = appState.uid
    self.profile = Profile.preview
  }
  
  func getProfile(for uid: String) async throws {
    let response = try await apiService.getUserData(accessToken: appState.token, uid: uid)
    switch response {
    case .success(let profile):
      self.profile = profile
    case .failure:
      self.profile = nil
    }
  }
  
  func logOut() {
    appState.logOut()
  }
  
  func follow() {
    Task {
      try await apiService.followUser(accessToken: appState.token, uid: uid)
      try await getProfile(for: uid)
    }
  }
  
  func unfollow() {
    Task {
      try await apiService.followUser(accessToken: appState.token, uid: uid)
      try await getProfile(for: uid)
    }
  }
}
