//
//  AttributedLabel.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import SwiftUI

struct AttributedLabel: View {
  let key: String
  let value: String
  
  private var keyAttributedString: AttributedString {
    var result = AttributedString(key)
    result.font = FontStyle.body.font
    result.foregroundColor = .layerTwo
    return result
  }
  
  private var valueAttributedString: AttributedString {
    var result = AttributedString(value)
    result.font = FontStyle.bodySecondary.font
    result.foregroundColor = .layerOne
    return result
  }
  
  var body: some View {
    Text(keyAttributedString + valueAttributedString)
  }
}

#Preview {
  AttributedLabel(key: "Rover: ", value: "Curiosity")
}
