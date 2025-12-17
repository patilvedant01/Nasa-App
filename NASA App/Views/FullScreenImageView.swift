//
//  FullScreenImageView.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import SwiftUI

struct FullScreenImageView: View {
    let urlString: String?
    @Binding var isPresented: Bool
    @StateObject private var loader = AsyncImageLoader()
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                    if scale < 1 {
                                        withAnimation {
                                            scale = 1
                                            lastScale = 1
                                            offset = .zero
                                            lastOffset = .zero
                                        }
                                    } else if scale > 4 {
                                        withAnimation {
                                            scale = 4
                                            lastScale = 4
                                        }
                                    }
                                },
                            DragGesture()
                                .onChanged { value in
                                    if scale > 1 {
                                        let newOffset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                        
                                        // Calculate max allowed offset based on scale
                                        let maxOffsetX = (UIScreen.main.bounds.width * (scale - 1)) / 2
                                        let maxOffsetY = (UIScreen.main.bounds.height * (scale - 1)) / 2
                                        
                                        // Clamp offset within bounds
                                        offset = CGSize(
                                            width: min(max(newOffset.width, -maxOffsetX), maxOffsetX),
                                            height: min(max(newOffset.height, -maxOffsetY), maxOffsetY)
                                        )
                                    }
                                }
                                .onEnded { _ in
                                    if scale > 1 {
                                        lastOffset = offset
                                    }
                                }
                        )
                    )
                    .onTapGesture(count: 2) {
                        withAnimation {
                            if scale > 1 {
                                scale = 1
                                lastScale = 1
                                offset = .zero
                                lastOffset = .zero
                            } else {
                                scale = 2
                                lastScale = 2
                            }
                        }
                    }
            } else {
                GenericLoadingView()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .task {
            await loader.loadImage(from: urlString)
        }
    }
}

#Preview {
    FullScreenImageView(
        urlString: "https://apod.nasa.gov/apod/image/1901/IC405_Abolfath_3952.jpg",
        isPresented: .constant(true)
    )
}
