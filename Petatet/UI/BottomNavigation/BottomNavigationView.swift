//
//  BottomNavigationView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.
//

import SwiftUI

struct BottomNavigationView: View {
  let container: DIContainer
    var body: some View {
      TabView {
        FeedView(viewModel: FeedViewModel(container: container, type: .main))
          .tabItem {
            Image(systemName: "house")
          }
          .tag(0)
        
        NewPostView(viewModel: NewPostViewModel(container: container))
          .tabItem {
            Image(systemName: "plus.app")
          }
          .tag(1)
        
        ForAdoptionView(container: container)
          .tabItem {
            Image(systemName: "pawprint.fill")
          }
          .tag(2)
        
        Text("Profile view coming soon!")
          .bold()
          .foregroundColor(.orange)
          .tabItem {
            Image(systemName: "person.crop.circle")
          }
          .tag(3)
      }
      .opacity(1)
      .accentColor(.orange)
    }
}

#Preview {
  BottomNavigationView(container: .preview)
}
