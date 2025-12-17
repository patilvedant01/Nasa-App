//
//  APODImageView.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import SwiftUI

struct APODImageView: View {
    let urlString: String
    let mediaType: APODMediaType
    @StateObject private var loader = AsyncImageLoader()
    
    var body: some View {
        Group {
            switch mediaType {
            case .video:
                VideoThumbnailView(urlString: urlString)
            case .image, .unknown:
                ZStack {
                    if let image = loader.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if loader.isLoading {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                            GenericLoadingView()
                        }
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    }
                }
                .task {
                    await loader.loadImage(from: urlString)
                }
            }
        }
    }
}

#Preview {
    VStack {
        APODImageView(
            urlString: "https://apod.nasa.gov/apod/image/1901/IC405_Abolfath_3952.jpg",
            mediaType: .image
        )
        APODImageView(
            urlString: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
            mediaType: .video
        )
        APODImageView(
            urlString: "https://apod.nasa.gov/apod/image/1901/IC405_Abolfath_3952.jpg",
            mediaType: .unknown
        )
    }
}

