//
//  Untitled.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation
import UIKit
import CryptoKit

class ImageCacheService {
    static let shared = ImageCacheService()
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskDirectoryURL: URL

    private init() {
        cache.countLimit = 100

        // disk cache
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dir = caches.appendingPathComponent("ImageCache", isDirectory: true)
        diskDirectoryURL = dir

        // Create directory if needed
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
    }
    
    func getImage(forKey key: String) -> UIImage? {
        // firstly check for Memory cache
        if let image = cache.object(forKey: key as NSString) {
            return image
        }

        // then check for Disk cache
        let url = fileURL(forKey: key)
        if let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            // put to memory
            cache.setObject(image, forKey: key as NSString)
            return image
        }

        return nil
    }

    func setImage(_ image: UIImage, forKey key: String) {
        // set Memory
        cache.setObject(image, forKey: key as NSString)

        // set Disk
        let url = fileURL(forKey: key)
        let data = image.jpegData(compressionQuality: 1.00)
        if let data {
            try? data.write(to: url, options: [.atomic])
        }
    }

    private func fileURL(forKey key: String) -> URL {
        let name = hashedFileName(for: key)
        return diskDirectoryURL.appendingPathComponent(name).appendingPathExtension("img")
    }

    private func hashedFileName(for key: String) -> String {
        if let data = key.data(using: .utf8) {
            let digest = SHA256.hash(data: data)
            return digest.compactMap { String(format: "%02x", $0) }.joined()
        } else {
            return key.replacingOccurrences(of: "[^A-Za-z0-9_.-]", with: "_", options: .regularExpression)
        }
    }
}

