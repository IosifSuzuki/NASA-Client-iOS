//
//  CardHistoryView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import SwiftUI

struct CardHistoryView: View {
  let model: CardHistoryModel
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 6) {
        Rectangle()
          .frame(height: 1)
          .foregroundStyle(.accentOne)
        Text(model.filters)
          .appFont(with: .titleSecondary)
          .foregroundStyle(.accentOne)
      }
      AttributedLabel(key: "\(String(localized: "Rover")): ", value: model.rover)
      AttributedLabel(key: "\(String(localized: "Camera")): ", value: model.camera)
      AttributedLabel(key: "\(String(localized: "Date")): ", value: model.date)
    }
    .padding(.all, 16)
    .appBackgroundShadow(with: 30)
  }
}

#Preview {
  let model = CardHistoryModel(
    id: 0,
    rover: "Curiosity",
    camera: "Front Hazard Avoidance Camera",
    date: "June 6, 2019"
  )
  return CardHistoryView(model: model)
}
