//
//  NewPostView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 22/06/2024.
//

import SwiftUI
import PhotosUI

struct NewPostView: View {
  @ObservedObject var viewModel: NewPostViewModel
  @FocusState var focused: Bool
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Text(focused ? "Caption" : "New Post")
          .bold()
          .padding()
        Divider()
        TextEditor(text: $viewModel.userInput)
          .foregroundColor(viewModel.userInput == viewModel.placeHolder ? .gray : .primary)
          .focused($focused)
          .frame(height: geometry.size.height * 0.1)
          .padding()
//          .overlay(
//            RoundedRectangle(cornerRadius: geometry.size.width * 0.07)
//              .stroke(.orange, lineWidth: 2)
//          )
          .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
              withAnimation {
                if viewModel.userInput == viewModel.placeHolder {
                  viewModel.userInput = ""
                }
              }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
              withAnimation {
                if viewModel.userInput == "" {
                  viewModel.userInput = viewModel.placeHolder
                }
              }
            }
          }
        VStack {
          Divider()
          switch viewModel.pickerState {
          case .neutral:
            PhotosPicker(selection: $viewModel.selectedPhotos,
                         matching: .images) {
              HStack {
                Image(systemName: "photo.on.rectangle.angled")
                  .resizable()
                  .frame(width: geometry.size.width * 0.05,
                         height: geometry.size.width * 0.05)
                  .foregroundColor(.orange)
                  .padding(.leading)
                Text("Add Photos")
                  .foregroundStyle(.orange)
                Spacer()
                Image(systemName: "chevron.right")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: geometry.size.width * 0.02)
                  .foregroundColor(.orange)
                  .padding(.trailing)
              }
            }
            Divider()
            PhotosPicker(selection: $viewModel.selectedVideo,
                         matching: .videos) {
              HStack {
                Image(systemName: "video.circle")
                  .resizable()
                  .frame(width: geometry.size.width * 0.05,
                         height: geometry.size.width * 0.05)
                  .foregroundColor(.orange)
                  .padding(.leading)
                Text("Add Video")
                  .foregroundStyle(.orange)
                Spacer()
                Image(systemName: "chevron.right")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: geometry.size.width * 0.02)
                  .foregroundColor(.orange)
                  .padding(.trailing)
              }
            }
          case .presentingPhotos:
            EmptyView()
          case .presentingVideo:
            EmptyView()
          }
//          Divider()
//          Button(action: {}) {
//            HStack{
//              Text("Upload")
//                .bold()
//                .foregroundColor(.white)
//              Image(systemName: "pawprint.fill")
//                .foregroundColor(.white)
//            }
//            .padding(10)
//            .background(viewModel.isValid ? .orange : .gray)
//            .cornerRadius(10)
//            .disabled(!viewModel.isValid)
//          }
          Spacer()
        }
        .overlay {
          if focused {
            Color.black.opacity(0.5)
          }
        }
      }
      .onTapGesture {
        self.focused = false
      }
    }
  }
}

#Preview {
  NewPostView(viewModel: NewPostViewModel(container: .preview))
}
