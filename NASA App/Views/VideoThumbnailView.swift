//
//  VideoThumbnailView.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import SwiftUI

struct VideoThumbnailView: View {
    let urlString: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 12) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text("Video Content")
                    .foregroundColor(.white)
                    .font(.headline)
                
                if let url = URL(string: urlString) {
                    Link("Watch on NASA", destination: url)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    VideoThumbnailView(urlString: "https://images-assets.nasa.gov/video/NHQ_2024_0613_SLS%20Core%20Stage%20for%20Artemis%20II%20Moves%20to%20Final%20Assembly/NHQ_2024_0613_SLS%20Core%20Stage%20for%20Artemis%20II%20Moves%20to%20Final%20Assembly~orig.mp4")
}
