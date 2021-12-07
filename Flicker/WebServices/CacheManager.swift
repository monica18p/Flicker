//
//  CacheManager.swift
//  Flicker
//
//  Created by Monica Pandey on 06/12/2021.
//

import Foundation
import UIKit

class CacheManager {
  private let imageCache = NSCache<NSString, UIImage>()
  init() {}
  
  // Make CacheManager fetch just one image with a particular index.
  func fetchImage(atIndex index: Int, resizedTo size: CGSize, photoInfo: PhotoInfo) async throws -> (UIImage, Int) {
    
    let imageKey = NSString(string: "image\(index)")
    
    if let cachedImage = imageCache.object(forKey: imageKey) {
      print("Fetching from cache...")
      return (cachedImage, index)
    }
    
    print("Fetching fresh...")
    
    // Make image loading asynchronous, moving the work off the main queue.
    
    print("Triggering download for \(photoInfo.id)")
    async let data = try await SearchImageAPIService.downloadImage(info: photoInfo)
    let asyncData = try await data
    let image = UIImage(data: asyncData)
    let resizedImage = image!.resized(to: size)
    self.imageCache.setObject(resizedImage, forKey: imageKey)
    return (resizedImage, index)
  }
  
  func clearCache() {
    imageCache.removeAllObjects()
  }
}
