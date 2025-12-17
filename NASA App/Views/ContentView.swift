//
//  ContentView.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: APODViewModel
    @State private var showDatePicker = false
    @State private var showFullScreen = false
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(viewModel: APODViewModel = APODViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    GenericLoadingView()
                } else if let error = viewModel.error {
                    GenericErrorView(error: error) {
                        Task {
                            await viewModel.retry()
                        }
                    }
                } else if let apod = viewModel.apodData {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            APODImageView(
                                urlString: apod.hdurl ?? apod.url,
                                mediaType: apod.mediaType
                            )
                            .onTapGesture {
                                if apod.mediaType != .other && (apod.hdurl != nil || apod.url != nil) {
                                    showFullScreen = true
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text(apod.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(apod.date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                if let copyright = apod.copyright {
                                    Text("© \(copyright)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Divider()
                                
                                Text(apod.explanation)
                                    .font(.body)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .fullScreenCover(isPresented: $showFullScreen) {
                        FullScreenImageView(
                            urlString: apod.hdurl ?? apod.url,
                            isPresented: $showFullScreen
                        )
                    }
                }
            }
            .navigationTitle("NASA APOD")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {                
                    Button(action: { themeManager.toggleLightDark() }) {
                        Image(systemName: themeManager.theme.iconName)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showDatePicker.toggle() }) {
                        Image(systemName: "calendar")
                    }
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerView(
                    selectedDate: $viewModel.selectedDate,
                    onDateSelected: { date in
                        Task {
                            await viewModel.fetchAPOD(for: date)
                        }
                    }
                )
            }
            .task {
                await viewModel.fetchAPOD()
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(ThemeManager())
}
