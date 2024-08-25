//
//  PersistenceContainer.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import Foundation
import CoreData

class PersistenceContainer {
  let container = NSPersistentContainer(name: "scheme")
  
  static let shared = PersistenceContainer()
  
  private init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
  }
}
