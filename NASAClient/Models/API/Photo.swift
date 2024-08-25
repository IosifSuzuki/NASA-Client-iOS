//
//  Photo.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import Foundation

struct Photo: Decodable {
  let id: Int
  let url: URL?
  let earthDate: Date
  let rover: Rover
  let camera: Camera
  
  enum CodingKeys: String, CodingKey {
    case id
    case url = "img_src"
    case earthDate = "earth_date"
    case rover
    case camera
  }
}
