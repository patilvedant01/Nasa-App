//
//  APODResponse.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation

enum APODMediaType: String, Codable, CaseIterable {
    case image
    case video
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = (try? container.decode(String.self))?.lowercased()
        if let raw, let value = APODMediaType(rawValue: raw) {
            self = value
        } else {
            self = .unknown
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .image, .video:
            try container.encode(self.rawValue)
        case .unknown:
            try container.encode("unknown")
        }
    }
}

struct APODResponse: Codable {
    let copyright: String?
    let date: String
    let explanation: String
    let hdurl: String?
    let mediaType: APODMediaType
    let serviceVersion: String
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}
