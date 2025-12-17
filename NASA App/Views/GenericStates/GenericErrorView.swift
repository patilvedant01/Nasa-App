//
//  ErrorView.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import SwiftUI

struct GenericErrorView: View {
    let error: APODError
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.title)
                .fontWeight(.bold)
            
            Text(error.localizedDescription)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            Button(action: retryAction) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    GenericErrorView(error: .decodingError, retryAction: {
        print("Retry button tapped.")
    })
}
