//
//  Camera.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import Foundation

struct Camera: Decodable {
  let id: Int
  let name: String
  let fullName: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case fullName = "full_name"
  }
}
