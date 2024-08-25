//
//  FilterDataManager.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import Foundation

class FilterDataManager {
  private let persistenceContainer: PersistenceContainer
  
  init(persistContainer: PersistenceContainer) {
    self.persistenceContainer = persistContainer
  }
  
  // MARK: - Public interface
  
  func save(filter: Filter) throws {
    guard !exist(filter: filter) else {
      return
    }
    let filterEntity = FilterEntity(context: persistenceContainer.container.viewContext)
    filterEntity.camera = filter.cameraOption.rawValue
    filterEntity.rover = filter.roverOption.rawValue
    filterEntity.date = filter.date
    try persistenceContainer.container.viewContext.save()
  }
  
  func delete(filter: Filter) throws {
    guard exist(filter: filter) else {
      return
    }
    if let filterEntity = try fetch(filter: filter) {
      persistenceContainer.container.viewContext.delete(filterEntity)
    }
    try persistenceContainer.container.viewContext.save()
  }
  
  func fetchAll() throws -> [Filter] {
    let request = FilterEntity.fetchRequest()
    let filterEntities = try persistenceContainer.container.viewContext.fetch(request)
    return filterEntities.compactMap { filterEntity in
      return map(filterEntity: filterEntity)
    }
  }
}

// MARK: - Private
private extension FilterDataManager {
  func fetch(filter: Filter) throws -> FilterEntity? {
    let request = FilterEntity.fetchRequest()
    let datePredicate = NSPredicate(
      format: "%K >= %@ AND %K <= %@", 
      #keyPath(FilterEntity.date),
      filter.date.startDay as NSDate, 
      #keyPath(FilterEntity.date),
      filter.date.endDay as NSDate
    )
    let predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(FilterEntity.rover), filter.roverOption.rawValue, #keyPath(FilterEntity.camera), filter.cameraOption.rawValue)
    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, predicate])
    request.fetchLimit = 1
    return try persistenceContainer.container.viewContext.fetch(request).first
  }
  
  func exist(filter: Filter) -> Bool {
    return (try? fetch(filter: filter)) != nil
  }
  
  func map(filterEntity: FilterEntity) -> Filter? {
    guard
      let roverOption = RoverOption(rawValue: filterEntity.rover ?? ""),
      let cameraOption = CameraOption(rawValue: filterEntity.camera ?? ""),
      let date = filterEntity.date
    else {
      return nil
    }
    return Filter(
      roverOption: roverOption,
      cameraOption: cameraOption,
      date: date
    )
  }
}
