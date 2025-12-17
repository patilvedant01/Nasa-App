//
//  DateFormatter.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import Foundation

extension DateFormatter {
    static let apodFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let apodMinDate: Date = {
        var components = DateComponents()
        components.year = 1995
        components.month = 6
        components.day = 16
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
