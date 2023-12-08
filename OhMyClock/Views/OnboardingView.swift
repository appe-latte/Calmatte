//
//  OnboardingView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-08.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    @State private var currentIndex = 0
    @State private var showSubscriptionPaywall = false

    var body: some View {
        ZStack {
            background()
            
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<viewModel.screens.count, id: \.self) { index in
                        OnboardingScreenView(screen: viewModel.screens[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                
                Button(action: {
                    if currentIndex < viewModel.screens.count - 1 {
                        currentIndex += 1
                    } else {
                        // When on the last screen, show subscription paywall
                        showSubscriptionPaywall = true
                    }
                }) {
                    Text(currentIndex < viewModel.screens.count - 1 ? "Next" : "Subscribe Now")
                }
                .padding()
                .sheet(isPresented: $showSubscriptionPaywall) {
                    CalmattePaywallView(showPaywall: .constant(false))
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct OnboardingScreenView: View {
    let screen: OnboardingScreen

    var body: some View {
        VStack {
            Image(screen.image)
                .resizable()
                .scaledToFit()
            
            Text(screen.title)
                .font(.title)
            
            Text(screen.description)
                .font(.body)
        }
    }
}

// MARK: Background
@ViewBuilder
func background() -> some View {
    GeometryReader { proxy in
        let size = proxy.size
        
        Image("img-bg")
            .resizable()
            .scaledToFill()
            .frame(height: size.height, alignment: .bottom)
        
        Rectangle()
            .fill(np_arsenic)
            .opacity(0.98)
            .frame(height: size.height, alignment: .bottom)
    }
    .ignoresSafeArea()
}
