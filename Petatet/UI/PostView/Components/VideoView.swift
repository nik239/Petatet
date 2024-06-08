//
//  VideoView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 04/05/2024.
//

import SwiftUI
import AVKit

struct VideoView: View {
  let loader: () async throws -> Media
  
  @State var player: AVPlayer?
  
  var body: some View {
    VStack {
      if player != nil {
        VideoPlayer(player: player)
//          .onTapGesture {
//            print("\(player!.status)")
//          }
      } else {
        EmptyView()
      }
    }
    .task {
      guard let media = try? await loader() else {
        print("Couldn't load video!")
        return
      }
      switch media {
      case Media.video(let asset):
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        player?.isMuted = true
        return
      default:
        return
      }
    }
    .onAppear {
      player?.play()
    }
  }
}

#Preview {
  return VideoView(loader: {
    StubMediaLoader().file(LocalFiles.dogMovie)
  })
}
