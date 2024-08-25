//
//  CameraOption.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import Foundation

enum CameraOption: String, CaseIterable {
  case fhaz
  case rhaz
  case mast
  case chemcam
  case mahli
  case mardi
  case navcam
  case pancam
  case minities
  
  var requestValue: String {
    switch self {
    case .fhaz:
      "fhaz"
    case .rhaz:
      "rhaz"
    case .mast:
      "mast"
    case .chemcam:
      "chemcam"
    case .mahli:
      "mahli"
    case .mardi:
      "mardi"
    case .navcam:
      "navcam"
    case .pancam:
      "pancam"
    case .minities:
      "minities"
    }
  }
  
  var fullName: String {
    switch self {
    case .fhaz:
      "Front Hazard Avoidance Camera"
    case .rhaz:
      "Rear Hazard Avoidance Camera"
    case .mast:
      "Mast Camera"
    case .chemcam:
      "Chemistry and Camera Complex"
    case .mahli:
      "Mars Hand Lens Imager"
    case .mardi:
      "Mars Descent Imager"
    case .navcam:
      "Navigation Camera"
    case .pancam:
      "Panoramic Camera"
    case .minities:
      "Miniature Thermal Emission Spectrometer (Mini-TES)"
    }
  }
  
  var shortName: String {
    switch self {
    case .fhaz:
      "FHAZ"
    case .rhaz:
      "RHAZ"
    case .mast:
      "MAST"
    case .chemcam:
      "CHEMCAM"
    case .mahli:
      "MAHLI"
    case .mardi:
      "MARDI"
    case .navcam:
      "NAVCAM"
    case .pancam:
      "PANCAM"
    case .minities:
      "MINITES"
    }
  }
  
}
