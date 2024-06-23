//
//  VideoPreView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 23/06/2024.
//

import SwiftUI
import AVKit

struct VideoPreView: View {
  @State var player: AVPlayer?
  var body: some View {
   // VStack {
      if player != nil {
        VideoPlayer(player: player)
          .task {
            player?.isMuted = true
          }
      } else {
        EmptyView()
      }
   // }
    //.frame(width: UIScreen.main.bounds.width)
    //.clipped()
//    .task {
//      player?.isMuted = true
//    }
  }
}

#Preview {
  VideoPreView()
}
