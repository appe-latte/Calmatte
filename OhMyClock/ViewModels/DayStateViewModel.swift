//
//  DayStateViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-08.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class DayStateViewModel: ObservableObject {
    @Published var dayStateFrequencies: [DayState: Int] = [:]
    
    init() {
        loadDayStateFrequencies()
    }
    
    private func loadDayStateFrequencies() {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userID).collection("moods").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            var newFrequencies = [DayState: Int]()

            for document in querySnapshot!.documents {
                // Assuming 'dayStates' is an array of strings
                if let dayStatesArray = document.data()["dayStates"] as? [String] {
                    for dayStateString in dayStatesArray {
                        if let dayState = DayState(rawValue: dayStateString) {
                            newFrequencies[dayState, default: 0] += 1
                        }
                    }
                }
            }

            DispatchQueue.main.async {
                self?.dayStateFrequencies = newFrequencies
            }
        }
    }
    
    func frequency(for state: DayState) -> Int {
        return dayStateFrequencies[state, default: 0]
    }
}



