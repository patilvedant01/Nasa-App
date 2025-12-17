//
//  Untitled.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation
import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
