//
//  LoadingRow.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import SwiftUI

struct LoadingRow: View {
  enum Style {
    case short
    case long
  }
  
  let style: Style
  
  var body: some View {
    HStack(spacing: 8) {
      if case .long = style {
        Text("\(String(localized: "Loading")) ...")
          .appFont(with: .body)
          .foregroundStyle(.accentOne)
      }
      ProgressView()
        .colorMultiply(.accent)
    }
  }
}

#Preview {
  Group {
    LoadingRow(style: .long)
    LoadingRow(style: .short)
  }
}
