//
//  ProfileView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 27/06/2024.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
  @ObservedObject var viewModel: ProfileViewModel
  @State var isOverlayed: Bool = false
  @State var selectedPhoto: PhotosPickerItem?
  var width: CGFloat = UIScreen.main.bounds.width
  var body: some View {
    VStack() {
      if let profile = viewModel.profile {
        HStack {
          if viewModel.isSelf {
            Image(systemName: "line.3.horizontal")
              .resizable()
              .scaledToFit()
              .frame(width: width * 0.05)
              .padding(.leading)
              .hidden()
          }
          Spacer()
          Text(profile.username ?? "")
            .font(.subheadline)
            .bold()
          Spacer()
          if viewModel.isSelf {
            Button(action: { isOverlayed = true }) {
              Image(systemName: "line.3.horizontal")
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.05)
                .foregroundColor(.black)
                .padding(.trailing)
            }
          }
        }
        HStack {
          VStack {
            ZStack {
              if let avatar = profile.avatar {
                PhotoView(loader: {try await viewModel.mediLoader.file(avatar)})
                  .frame(width: width * 0.2, height: width * 0.2)
                  .clipShape(.circle)
                  .padding(.horizontal, width * 0.02)
              } else {
                Image(systemName: "person.crop.circle")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .foregroundColor(.gray)
                  .frame(width: width * 0.2, height: width * 0.2)
                  .clipShape(.circle)
                  .padding(.horizontal, width * 0.02)
              }
              HStack {
                Spacer()
                VStack {
                  Spacer()
                  PhotosPicker(selection: $selectedPhoto,
                               matching: .images) {
                    Image(systemName: "plus.circle.fill")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: width * 0.05, height: width * 0.05)
                      .foregroundColor(.orange)
                      .background(.white)
                      .clipShape(.circle)
                  }
                }
              }
              .frame(width: width * 0.22, height: width * 0.22)
            }
            if let name = profile.displayName {
              Text(name)
                .font(.footnote)
                .bold()
            }
          }
          Spacer()
          
          if let details = profile.details {
            HStack {
              CountView(name: "Posts", count: details.postCount)
              CountView(name: "Followers", count: details.followersCount)
              CountView(name: "Following", count: details.followingCount)
            }
          }
          
          Spacer()
        }
      } else {
        Text("Couldn't load profile :(")
          .bold()
          .foregroundColor(.orange)
      }
      
      EquatableView(content: FeedView(viewModel: FeedViewModel(container: viewModel.container,
                                                              type: .profile(viewModel.uid))))
    }
    .overlay() {
      if isOverlayed == true {
        ZStack {
          Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
              isOverlayed = false
            }
          VStack {
            if viewModel.isSelf {
              Button(action: viewModel.logOut) {
                Text("Logout")
                  .foregroundStyle(.red)
              }
            } else {
              if viewModel.profile?.isFollowing == 1 {
                Button(action: viewModel.unfollow) {
                  Text("Unfollow")
                }
                
              } else {
                Button(action: viewModel.follow) {
                  Text("Follow")
                }
              }
            }
            Divider()
            Button(action: {self.isOverlayed = false}){
              Text("Cancel")
            }
          }
          .padding()
          .frame(width: width * 0.97)
          .background(.white)
          .cornerRadius(7)
        }
      }
    }
  }
}

#Preview {
  ProfileView(viewModel: ProfileViewModel())
}
