//
//  GenericLoadingView.swift
//  NASA App
//
//  Created by Vedant Patil on 16/12/25.
//

import SwiftUI

struct GenericLoadingView: View {
    var body: some View {
        ZStack {
            Color.clear
            VStack(spacing: 16) {
                RedRotatingRing(size: 44, lineWidth: 6)
                    .accessibilityLabel("Loading")
                    .accessibilityAddTraits(.isImage)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .ignoresSafeArea()
    }
}

private struct RedRotatingRing: View {
    let size: CGFloat
    let lineWidth: CGFloat

    @State private var rotate = false
    @State private var trimHead: CGFloat = 0.0
    @State private var trimTail: CGFloat = 0.0

    private var gradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [
                Color.red.opacity(0.15),
                Color.red.opacity(0.6),
                Color.red
            ]),
            center: .center
        )
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.red.opacity(0.15), lineWidth: lineWidth)

            Circle()
                .trim(from: trimHead, to: trimTail)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(rotate ? 360 : 0))
                .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: rotate)
                .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: trimTail)
                .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: trimHead)
        }
        .frame(width: size, height: size)
        .onAppear {
            rotate = true
            // Animate the arc length to create a tail that grows/shrinks
            trimHead = 0.0
            trimTail = 0.25
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                trimHead = 0.15
                trimTail = 0.85
            }
        }
        .onDisappear {
            rotate = false
        }
    }
}

#Preview {
    GenericLoadingView()
}
