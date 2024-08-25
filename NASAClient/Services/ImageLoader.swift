//
//  ImageLoader.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 25.08.2024.
//

import Foundation
import UIKit.UIImage

class ImageLoader: ObservableObject {
  enum State {
    case loading
    case failed(message: String)
    case finished(image: UIImage)
    
  }
  @Published var state: State = .loading
  private var url: URL?
  private var task: Task<Void, Error>?
  
  init(url: URL?) {
    self.url = url
    loadImage()
  }
  
  private func loadImage() {
    guard let url else {
      state = .failed(message: "No image")
      return
    }
    if let cachedImage = ImageCache.shared.get(forURL: url) {
      state = .finished(image: cachedImage)
      return
    }
    task?.cancel()
    state = .loading
    task = Task { @MainActor [url, weak self] in
      let (data, _) = try await URLSession.shared.data(from: url)
      if Task.isCancelled {
        self?.state = .failed(message: "Canceled loading")
        return
      }
      if let image = UIImage(data: data) {
        ImageCache.shared.set(image, forURL: url)
        self?.state = .finished(image: image)
      } else {
        self?.state = .failed(message: "No image")
      }
    }
  }
}
