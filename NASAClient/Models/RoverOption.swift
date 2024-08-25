//
//  Rovers.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import Foundation

enum RoverOption: CaseIterable {
  case curiosity
  case opportunity
  case spirit
  
  var name: String {
    switch self {
    case .curiosity:
      "Curiosity"
    case .opportunity:
      "Opportunity"
    case .spirit:
      "Spirit"
    }
  }
  
  var requestValue: String {
    switch self {
    case .curiosity:
      "curiosity"
    case .opportunity:
      "opportunity"
    case .spirit:
      "spirit"
    }
  }
  
  var availableCams: [CameraOption] {
    switch self {
    case .curiosity:
      [.fhaz, .rhaz, .mast, .chemcam, .mahli, .mardi, .navcam]
    case .opportunity:
      [.fhaz, .rhaz, .navcam, .pancam, .minities]
    case .spirit:
      [.fhaz, .rhaz, .navcam, .pancam, .minities]
    }
  }
}
