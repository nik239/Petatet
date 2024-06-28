//
//  ClearButtonView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 23/06/2024.
//

import SwiftUI

struct ToolbarView: View {
  @FocusState var focused: Bool
  @Binding var isUploading: Bool
  @Binding var userInput: String
  @Binding var pickerState: PickerState
  var clearCaption: () -> ()
  var clearMedia: () -> ()
  var uploadPost: () -> ()
  var body: some View {
    ZStack {
      if !isUploading {
        HStack {
          if focused {
            if userInput != "" {
              Button(action: clearCaption) {
                Text("Clear")
                  .foregroundColor(.red)
                  .padding(.leading)
              }
            } else {
              Text("Clear")
                .opacity(0)
                .padding(.leading)
            }
          } else {
            switch pickerState {
            case .neutral:
              Text("Detach")
                .opacity(0)
                .padding(.leading)
            default:
              Button(action: clearMedia){
                Text("Detach")
                  .foregroundColor(.red)
                  .padding(.leading)
              }
            }
          }
          Spacer()
          if focused {
            Button (action: {focused = false}){
              Text("OK")
                .foregroundColor(.blue)
                .padding(.trailing)
            }
          } else {
            if  pickerState != .neutral || (userInput != "" && userInput != "Write a caption...") {
              Button(action: uploadPost){
                Text("Share")
                  .foregroundColor(.blue)
                  .padding(.trailing)
              }
            } else {
              Text("Share")
                .foregroundColor(.gray)
                .padding(.trailing)
            }
          }
        }
      }
      if isUploading {
        Text("Uploading...")
          .bold()
          .padding()
      } else {
        Text(focused ? "Caption" : "New Post")
          .bold()
          .padding()
      }
    }
  }
}

//#Preview {
//    ClearButtonView()
//}
