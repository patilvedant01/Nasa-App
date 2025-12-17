//
//  Untitled.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import UIKit
import Foundation
import Combine

class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let cache = ImageCacheService.shared
    
    func loadImage(from urlString: String?) async {
        guard let urlString = urlString else {
            return
        }
        
        // Check cache first
        if let cachedImage = cache.getImage(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        isLoading = true
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                cache.setImage(uiImage, forKey: urlString)
                self.image = uiImage
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        
        isLoading = false
    }
}
