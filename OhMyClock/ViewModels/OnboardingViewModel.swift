//
//  OnboardingViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-08.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    let screens: [OnboardingScreen] = [
        OnboardingScreen(title: "Welcome", image: "welcome-image", description: "Welcome to our app!"),
        OnboardingScreen(title: "Feature 1", image: "feature1-image", description: "Discover our amazing feature 1."),
        OnboardingScreen(title: "Feature 2", image: "feature2-image", description: "Find out more about feature 2.")
    ]
}
