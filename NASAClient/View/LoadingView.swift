//
//  LoadingView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
      let keypath = AnimationKeypath(keys: ["**.Color"])
      let color = ColorValueProvider(UIColor(resource: .accentOne).lottieColorValue)
      
      VStack(spacing: 8) {
        Spacer()
        Text("\(String(localized: "Loading")) ...")
          .appFont(with: .large)
          .foregroundStyle(.accentOne)
        LottieView(animation: .named("loading-lottie"))
          .playing(loopMode: .loop)
          .valueProvider(color, for: keypath)
          .colorMultiply(.accent)
          .scaleEffect(6)
          .frame(height: 50)
        Spacer()
      }
    }
}

#Preview {
    LoadingView()
}
