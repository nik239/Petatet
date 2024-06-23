//
//  OrangeDivider.swift
//  Petatet
//
//  Created by Nikita Ivanov on 22/06/2024.
//

import SwiftUI

struct OrangeDivider: View {
  var body: some View {
    Rectangle()
      .fill(Color.orange)
      .frame(height: 1)
      .edgesIgnoringSafeArea(.horizontal)
  }
}
