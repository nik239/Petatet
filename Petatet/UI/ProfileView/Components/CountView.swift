//
//  CountView.swift
//  Petatet
//
//  Created by Nikita Ivanov on 27/06/2024.
//

import SwiftUI

struct CountView: View {
  let name: String
  let count: String
  var body: some View {
    VStack {
      Text(count)
        .bold()
      Text(name)
        .font(.footnote)
    }
    .padding()
  }
}

#Preview {
  CountView(name: "Followers", count: "1467")
}
