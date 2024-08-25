//
//  ImageCache.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import Foundation
import UIKit

class ImageCache {
  static let shared = ImageCache(countLimit: 500)
  
  private var cache: NSCache<NSString, UIImage>
  
  private init(countLimit: Int) {
    cache = NSCache()
    cache.countLimit = countLimit
  }
  
  func set(_ image: UIImage, forURL url: URL) {
    let id = cacheKey(forURL: url)
    cache.setObject(image, forKey: id as NSString)
  }
  
  func get(forURL url: URL) -> UIImage? {
    let id = cacheKey(forURL: url)
    return cache.object(forKey: id as NSString)
  }
  
  func cacheKey(forURL url: URL) -> String {
    Data(url.absoluteString.utf8).base64EncodedString()
  }
}
