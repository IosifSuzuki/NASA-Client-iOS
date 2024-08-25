//
//  ImageViewerCoordinator.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import SwiftUI

struct ImageViewerCoordinator: View {
  @Environment(\.dismiss) var dismiss
  let sourceURL: URL?
  
  var body: some View {
    NavigationStack {
      ZStack {
        Color(.layerOne)
        ImageViewerView(sourceURL: sourceURL)
          .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              dismissButton
            }
          }
          .toolbarBackground(.hidden, for: .navigationBar)
      }
      .ignoresSafeArea()
    }
  }
  
  private var dismissButton: some View {
    Button(action: {
      dismiss()
    }, label: {
      Image(.lightClose)
    })
  }
}

#Preview {
  let url = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/rcam/RLB_486265291EDR_F0481570RHAZ00323M_.JPG")!
  return ImageViewerCoordinator(sourceURL: url)
}
