//
//  APODViewModel.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation
import Combine

class APODViewModel: ObservableObject {
    @Published var apodData: APODResponse?
    @Published var isLoading = false
    @Published var error: APODError?
    @Published var selectedDate = Date()
    
    private let service: APODServiceProtocol
    
    init(service: APODServiceProtocol = APODService()) {
        self.service = service
    }
    
    func fetchAPOD(for date: Date? = nil) async {
        isLoading = true
        error = nil
        apodData = nil
        
        do {
            let response = try await service.fetchAPOD(for: date)
            self.apodData = response
        } catch let apodError as APODError {
            self.error = apodError
        } catch {
            self.error = .networkError(error)
        }
        
        isLoading = false
    }
    
    func retry() async {
        await fetchAPOD(for: selectedDate)
    }
}

