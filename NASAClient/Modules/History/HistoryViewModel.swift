//
//  HistoryViewModel.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import Foundation

class HistoryViewModel: ObservableObject {
  @Published var dataSource: [CardHistoryModel] = []
  
  let title = String(localized: "History.title")
  
  private let filterDataManager: FilterDataManager
  private var filters: [Filter] = []
  private var selectedFilter: Filter?
  
  init(filterDataManager: FilterDataManager) {
    self.filterDataManager = filterDataManager
  }
  
  func loadData() {
    do {
      filters = try filterDataManager.fetchAll()
      dataSource = filters
        .enumerated()
        .map { (idx, filter) in
          return CardHistoryModel(
            id: idx,
            rover: filter.roverOption.name,
            camera: filter.cameraOption.fullName,
            date: filter.date.toString(format: "MMMM d, yyyy")
          )
        }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func select(cardHistoryModel: CardHistoryModel) {
    guard filters.indices.contains(cardHistoryModel.id) else {
      return
    }
    selectedFilter = filters[cardHistoryModel.id]
  }
  
  func deleteFilter() {
    guard let selectedFilter else {
      return
    }
    do {
      try filterDataManager.delete(filter: selectedFilter)
      loadData()
    } catch {
      print(error)
    }
  }
}
