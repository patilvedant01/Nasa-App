//
//  GenericEmptyView.swift
//  NASA App
//
//  Created by Vedant Patil on 17/12/25.
//

import SwiftUI

struct GenericEmptyView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 300)
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.system(size: 48, weight: .regular))
                    .foregroundStyle(.secondary)
                
                Text("Content unavailable for the selected date. Please try a different date.")
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    GenericEmptyView()
}
