//
//  APODResponse.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation

enum APODMediaType: String, Codable {
    case image
    case video
    case other

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = (try? container.decode(String.self))?.lowercased()
        if let raw, let value = APODMediaType(rawValue: raw) {
            self = value
        } else {
            self = .other
        }
    }
}

struct APODResponse: Codable {
    let copyright: String?
    let date: String
    let explanation: String
    let hdurl: String?
    let mediaType: APODMediaType
    let title: String
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case title, url
    }
}
