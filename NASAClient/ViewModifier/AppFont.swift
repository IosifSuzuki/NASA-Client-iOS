//
//  AppFont.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import SwiftUI

extension View {
  func appFont(with fontStyle: FontStyle) -> some View {
    self.modifier(AppFont(fontStyle: fontStyle))
  }
}

enum FontStyle {
  case large
  case title
  case titleSecondary
  case body
  case bodySecondary
  
  var fontSize: CGFloat {
    switch self {
    case .large:
      34
    case .title:
      22
    case .titleSecondary:
      22
    case .body:
      17
    case .bodySecondary:
      16
    }
  }
  
  var fontWeight: Font.Weight {
    switch self {
    case .large:
        .bold
    case .title:
        .regular
    case .titleSecondary:
        .bold
    case .body:
        .regular
    case .bodySecondary:
        .bold
    }
  }
  
  var fontHeight: CGFloat {
    switch self {
    case .large:
      41
    case .title:
      28
    case .titleSecondary:
      28
    case .body:
      21
    case .bodySecondary:
      22
    }
  }
  
  var font: Font {
    .system(size: fontSize, weight: fontWeight)
  }
}

struct AppFont: ViewModifier {
  let font: Font
  let fontSize: CGFloat
  let height: CGFloat
  let fontWeight: Font.Weight
  
  init(fontStyle: FontStyle) {
    font = fontStyle.font
    fontSize = fontStyle.fontSize
    height = fontStyle.fontHeight
    fontWeight = fontStyle.fontWeight
  }
  
  func body(content: Content) -> some View {
    content
      .multilineTextAlignment(.leading)
      .font(font)
      .fontWeight(fontWeight)
      .lineSpacing(abs(height - fontSize))
  }
}
