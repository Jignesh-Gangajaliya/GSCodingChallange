//
//  ImageLoader.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 27/03/22.
//

import UIKit

public class ImageLoader {

  private static let cache = NSCache<NSString, NSData>()

  class func image(for url: URL, completionHandler: @escaping(_ image: UIImage?) -> ()) {
    DispatchQueue.global(qos: .background).async {
      if let data = self.cache.object(forKey: url.absoluteString as NSString) {
        print("Display From Cache")
        DispatchQueue.main.async {
            completionHandler(UIImage(data: data as Data))
        }
        return
      }

      guard let data = NSData(contentsOf: url) else {
        DispatchQueue.main.async {
            completionHandler(nil)
        }
        return
      }
      self.cache.setObject(data, forKey: url.absoluteString as NSString)
      DispatchQueue.main.async {
        print("Loaded From Data")
        completionHandler(UIImage(data: data as Data))
      }
    }
  }
}
