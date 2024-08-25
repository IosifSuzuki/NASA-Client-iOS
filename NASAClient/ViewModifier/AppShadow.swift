//
//  AppShadow.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import SwiftUI

extension View {
  func appBackgroundShadow(with cornerRadius: CGFloat) -> some View {
    self.modifier(AppBackgroundShadow(cornerRadius: cornerRadius))
  }
}

struct AppBackgroundShadow: ViewModifier {
  let cornerRadius: CGFloat
  func body(content: Content) -> some View {
    content
      .background {
        Rectangle()
          .fill(Color.backgroundOne)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
          .shadow(color: .black.opacity(0.08), radius: 16, y: 3)
      }
  }
}
