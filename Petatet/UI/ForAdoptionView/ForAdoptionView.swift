//
//  ForAdoptionView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 26/06/2024.
//

import SwiftUI

struct ForAdoptionView: View {
  let container: DIContainer
  @State var animal: Animal = .cats
  let width: CGFloat = UIScreen.main.bounds.width
  var body: some View {
    VStack {
      Picker("Animal", selection: $animal) {
        ForEach(Animal.allCases) {
          Text($0.rawValue.capitalized)
        }
      }
      .pickerStyle(.segmented)
      .frame(width: width * 0.5)
      switch animal {
      case .cats:
        FeedView(viewModel: FeedViewModel(container: container, type: .catsForAdoption))
      case .dogs:
        FeedView(viewModel: FeedViewModel(container: container, type: .dogsForAdoption))
      }
    }
  }
}

#Preview {
  ForAdoptionView(container: .preview)
}

extension ForAdoptionView {
  enum Animal: String, CaseIterable, Identifiable {
    case cats
    case dogs
    var id: Self { self }
  }
}
