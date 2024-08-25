//
//  NoDataView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import SwiftUI

struct NoDataView: View {
  let title: String
  let image: Image
  
  var body: some View {
    VStack(spacing: 20) {
      image
        .resizable()
        .scaledToFit()
        .frame(width: 145, height: 145)
      Text(title)
        .multilineTextAlignment(.center)
        .appFont(with: .body)
        .foregroundStyle(.layerTwo)
    }
    .background {
      Color.backgroundOne
    }
  }
}

#Preview {
  Group {
    NoDataView(
      title: "Browsing history is empty.",
      image: Image(.emptyHistory)
    )
    NoDataView(
      title: String(localized: "Home.Photos.noData"),
      image: Image(systemName: "tray")
    )
    NoDataView(
      title: "No internet connection",
      image: Image(systemName: "bolt.trianglebadge.exclamationmark")
    )
  }
  .fontWeight(.ultraLight)
  .foregroundStyle(.accent)
}
