//
//  CardHistoryModel.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import Foundation

struct CardHistoryModel {
  var filters: String {
    String(localized: "Filters")
  }
  
  let id: Int
  let rover: String
  let camera: String
  let date: String
}
