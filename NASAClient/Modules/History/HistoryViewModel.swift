//
//  HistoryViewModel.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import Foundation

class HistoryViewModel: ObservableObject {
  let title = String(localized: "History.title")
  @Published var dataSource: [CardHistoryModel] = []
  
  func loadData() {
    dataSource = [
      CardHistoryModel(id: 0, rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019"),
      CardHistoryModel(id: 1, rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019"),
      CardHistoryModel(id: 2, rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019"),
      CardHistoryModel(id: 3, rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019"),
      CardHistoryModel(id: 4, rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019"),
      CardHistoryModel(id: 5, rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019"),
      CardHistoryModel(id: 6, rover: "Curiosity", camera: "Front Hazard Avoidance Camera", date: "June 6, 2019"),
    ]
  }
}
