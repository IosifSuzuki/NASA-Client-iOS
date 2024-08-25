//
//  ImageViewerView.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 24.08.2024.
//

import SwiftUI

struct ImageViewerView: UIViewControllerRepresentable {
  let sourceURL: URL?
  func makeUIViewController(context: Context) -> some UIViewController {
    let viewController = ImageViewController.instantiate(with: sourceURL)
    return viewController
  }
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

#Preview {
  let url = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/rcam/RLB_486265291EDR_F0481570RHAZ00323M_.JPG")!
  
  return ImageViewerView(sourceURL: url)
}
