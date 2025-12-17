//
//  DatePickerView.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    let onDateSelected: (Date) -> Void
    @Environment(\.dismiss) private var dismiss
    
    private let minDate = DateFormatter.apodMinDate
    private let maxDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select a date to view APOD")
                    .font(.headline)
                    .padding(.top)
                
                DatePicker(
                    "Date",
                    selection: $selectedDate,
                    in: minDate...maxDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Button(action: {
                    onDateSelected(selectedDate)
                    dismiss()
                }) {
                    Text("View APOD")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    DatePickerView(
        selectedDate: .constant(Date()),
        onDateSelected: { _ in }
    )
}
