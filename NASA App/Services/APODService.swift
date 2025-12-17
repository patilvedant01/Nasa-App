//
//  APODService.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation

protocol APODServiceProtocol {
    func fetchAPOD(for date: Date?) async throws -> APODResponse
}

class APODService: APODServiceProtocol {
    private let apiKey = "ZZtgNrUskPrP1L3bHm4Vk23bvjL11TQzZxGf8eSx"
    private let baseURL = "https://api.nasa.gov/planetary/apod"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchAPOD(for date: Date? = nil) async throws -> APODResponse {
        var components = URLComponents(string: baseURL)
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        if let date = date {
            // Validate date
            let minDate = DateFormatter.apodMinDate
            let maxDate = Date()
            
            if date < minDate || date > maxDate {
                throw APODError.invalidDate
            }
            
            let dateString = DateFormatter.apodFormatter.string(from: date)
            queryItems.append(URLQueryItem(name: "date", value: dateString))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw APODError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APODError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            let apodResponse = try decoder.decode(APODResponse.self, from: data)
            return apodResponse
            
        } catch is DecodingError {
            throw APODError.decodingError
        } catch {
            throw APODError.networkError(error)
        }
    }
}
