//
//  FilterItemView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import SwiftUI

struct FilterItemView: View {
  let title: String
  let icon: Image
  let action: () -> ()
    var body: some View {
        Button(action: {
          action()
        }, label: {
          HStack(spacing: 6) {
            icon
            Text(title)
              .appFont(with: .bodySecondary)
              .foregroundStyle(.layerOne)
              .lineLimit(1)
            Spacer()
          }
          .padding(.all, 7)
          .frame(width: 140)
        })
        .background {
          RoundedRectangle(cornerRadius: 10)
            .fill(.backgroundOne)
            .appBackgroundShadow(with: 10)
        }
      }
}

#Preview {
  FilterItemView(
    title: "All",
    icon: Image(.rover),
    action: {}
  ).frame(width: 140, height: 30)
}
