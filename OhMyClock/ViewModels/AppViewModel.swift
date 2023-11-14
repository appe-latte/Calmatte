//
//  AppViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-14.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var isLoading = false

    // Example function to simulate data loading
    func loadData() {
        isLoading = true
        // Simulate a network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Data loading is complete
            self.isLoading = false
        }
    }
}
