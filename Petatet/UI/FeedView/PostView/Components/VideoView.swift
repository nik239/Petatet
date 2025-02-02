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
      } else {
        EmptyView()
      }
    }
    .task {
      //print("loading media!")
      guard let media = try? await loader() else {
        print("Couldn't load video!")
        return
      }
      switch media {
      case Media.video(let asset):
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        player?.isMuted = true
        player?.play()
        return
      default:
        return
      }
    }
  }
}

#Preview {
  return VideoView(loader: {
    StubMediaLoader().file(LocalFiles.dogMovie)
  })
}
