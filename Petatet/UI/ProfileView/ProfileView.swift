//
//  ProfileView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 27/06/2024.
//

import SwiftUI

struct ProfileView: View {
  @ObservedObject var viewModel: ProfileViewModel
  var width: CGFloat = UIScreen.main.bounds.width
  var body: some View {
    VStack() {
      if let profile = viewModel.profile {
        HStack {
          Spacer()
          Button(action: {}) {
            Image(systemName: "ellipsis")
              .resizable()
              .scaledToFit()
              .frame(width: width * 0.05)
              .padding()
          }
        }
        HStack {
          if let avatar = profile.avatar {
            PhotoView(loader: {try await viewModel.mediLoader.file(avatar)})
              .frame(width: width * 0.2, height: width * 0.2)
              .clipShape(.circle)
              .padding(.horizontal, width * 0.02)
          }
          if let name = profile.displayName {
            Text(name)
              .font(.title2)
              .bold()
          }
          Spacer()
        }
      } else {
        Text("Couldn't load profile :(")
          .bold()
          .foregroundColor(.orange)
      }
      FeedView(viewModel: FeedViewModel(container: viewModel.container,
                                        type: .profile(viewModel.uid)))
    }
  }
}

#Preview {
  ProfileView(viewModel: ProfileViewModel())
}
