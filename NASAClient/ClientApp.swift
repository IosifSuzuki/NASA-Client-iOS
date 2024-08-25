//
//  ClientApp.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import SwiftUI

@main
struct ClientApp: App {
  
  init() {
    _ = PersistenceContainer.shared
  }
  
  var body: some Scene {
      WindowGroup {
        HomeCoordinator()
      }
  }
}
