//
//  CursedVideoPlayer.swift
//  Petatet
//
//  Created by Nikita Ivanov on 09/05/2024.


import SwiftUI

import SwiftUI
import AVKit

struct CursedVideoView: View {
  let loader = {URL(string: "file:///Users/nikitaivanov/Library/Developer/CoreSimulator/Devices/45FEF83D-944A-49EF-B3D0-F68FEA86AA8A/data/Containers/Data/Application/C795B70A-ED6B-4382-BB20-7A95EC47A72B/tmp/Alamofire_CFNetworkDownload_AxsVS4.tmp")!}
  
  @State var player: AVPlayer?
  @State var asset: AVAsset?
  @State var tracks: [AVAssetTrack]?
  
  var body: some View {
    VStack {
      Text("\(asset?.tracks)")
      if player != nil {
        VideoPlayer(player: player)
          .onTapGesture {
            print("\(player!.status)")
            print("\(asset)")
          }
      } else {
        EmptyView()
      }
    }
    .task {
      guard let localURL = try? loader() else {
        print("Couldn't load video!")
        return
      }
//      let localURL = originalURL.deletingPathExtension().appendingPathExtension("mov")
      asset = AVAsset(url: localURL)
      tracks = try? await asset?.loadTracks(withMediaType: .video)
      print("Creating player from url: \(localURL)")
      player = AVPlayer(url: localURL)
      if let player = player {
        print("Player created successfully!")
        print("Player status: \(player.status)")
        player.isMuted = true
      }
      //print("Player status: \(player.Status)")
    }
    .onAppear {
      player?.play()
    }
  }
}

#Preview {
  return CursedVideoView()
}
