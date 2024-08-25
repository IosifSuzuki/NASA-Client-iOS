//
//  RemoteIMage.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import SwiftUI

struct RemoteImage: View {
  @ObservedObject var imageLoader: ImageLoader
  
  init(url: URL?) {
    imageLoader = ImageLoader(url: url)
  }
  
  var body: some View {
    switch imageLoader.state {
    case .loading:
      LoadingRow(style: .short)
    case .failed(let message):
      Text(message)
        .appFont(with: .bodySecondary)
        .foregroundStyle(.layerOne)
    case .finished(let image):
      Image(uiImage: image)
        .resizable()
    }
  }
}

#Preview {
  let url = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/rcam/RLB_486265291EDR_F0481570RHAZ00323M_.JPG")!
  return RemoteImage(url: url)
}
