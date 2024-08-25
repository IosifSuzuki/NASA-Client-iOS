//
//  Endpoints.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import Foundation

enum NASAEndpoints: HTTP.Endpoint {
  case photos(roverOption: RoverOption, cameraOption: CameraOption, date: Date, page: Int)
  
  var domain: String {
    "api.nasa.gov"
  }
  
  var path: String {
    switch self {
    case let .photos(roverOption, _, _, _):
      return "/mars-photos/api/v1/rovers/\(roverOption.requestValue)/photos"
    }
  }
  
  var parameters: [URLQueryItem] {
    let apiKeyURLQueryItem = URLQueryItem(name: "api_key", value: "DEMO_KEY")
    var queryItems: [URLQueryItem] = [apiKeyURLQueryItem]
    switch self {
    case let .photos(_, cameraOption, date, page):
      let dateURLQueryItem = URLQueryItem(name: "earth_date", value: date.toString())
      let pageURLQueryItem = URLQueryItem(name: "page", value: "\(page)")
      let cameraURLQueryItem = URLQueryItem(name: "camera", value: "\(cameraOption.requestValue)")
      queryItems.append(contentsOf: [dateURLQueryItem, pageURLQueryItem, cameraURLQueryItem])
    }
    return queryItems
  }
  
  var headers: [String: String] {
    [:]
  }
  
  var method: HTTP.Method {
    .get
  }
}
