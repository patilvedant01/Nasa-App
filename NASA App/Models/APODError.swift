//
//  APODError.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation

enum APODError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
    case invalidDate
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode data"
        case .invalidDate:
            return "Invalid date. Please select a date between June 16, 1995 and today."
        }
    }
}
