//
//  MoodModelController.swift
//  OhMyClock
//
//  Created by Nelson Gonzalez on 3/27/20.
//  Modified by Stanford L. Khumalo on 2023-07-11.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class MoodModelController: ObservableObject {
    
    //MARK: - Properties
    @Published var moods: [Mood] = []
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var totalDaysLogged: Int = 0
    
    let db = Firestore.firestore()
    
    init() {
        loadFromFirestore()
    }
    
    // MARK: - Create Mood / Day State
    func createMood(emotion: Emotion, comment: String?, date: Date, dayState: DayMoodState) {
        // Wrap the single dayState in an array when initializing the Mood object
        let newMood = Mood(emotion: emotion, comment: comment, date: date, dayStates: [dayState])
        
        moods.append(newMood)
        saveToFirestore()
        calculateStreaks()
    }

    // MARK: "Delete" mood
    func deleteMood(withID uuid: UUID) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userID).collection("moods").document(uuid.uuidString).delete { [weak self] err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                DispatchQueue.main.async {
                    self?.moods.removeAll { $0.id == uuid }
                    self?.calculateStreaks()
                }
            }
        }
    }
    
    // MARK: "Update" mood
    func updateMoodComment(mood: Mood, comment: String) {
        if let index = moods.firstIndex(of: mood) {
            var mood = moods[index]
            mood.comment = comment
            
            moods[index] = mood
            saveToFirestore()
            calculateStreaks()
        }
    }
    
    // MARK: Save, Load from Persistence
    private var persistentFileURL: URL? {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        
        return documents.appendingPathComponent("mood.plist")
    }
    
    // MARK: Save Journal To Firebase
    func saveToFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        for mood in moods {
            do {
                let moodData = try mood.asDictionary()
                let moodID = mood.id.uuidString
                db.collection("users").document(userID).collection("moods").document(moodID).setData(moodData, merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            } catch let error {
                print("Error writing moods to Firestore: \(error)")
            }
        }
    }
    
    // MARK: Load Journal From Firebase
    func loadFromFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        moods = []
        
        db.collection("users").document(userID).collection("moods").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting moods: \(err)")
            } else {
                self.moods = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let decoder = JSONDecoder()
                        let mood = try decoder.decode(Mood.self, from: jsonData)
                        return mood
                    } catch let error {
                        print("Error decoding mood: \(error)")
                        return nil
                    }
                } ?? []
                
                DispatchQueue.main.async {
                    self.calculateStreaks()
                }
            }
        }
    }
    
    // MARK: Calculating "Streaks"
    func calculateStreaks() {
        guard !moods.isEmpty else { return }

        let calendar = Calendar.current
        let sortedMoods = moods.sorted(by: { $0.date < $1.date })
        var currentStreak = 0
        var bestStreak = 0
        var lastDate: Date?

        for mood in sortedMoods {
            if let lastDateUnwrapped = lastDate {
                if calendar.isDate(mood.date, inSameDayAs: lastDateUnwrapped) {
                    continue // Skip if the mood was logged on the same day
                }

                let dateDiff = calendar.dateComponents([.day], from: lastDateUnwrapped, to: mood.date).day ?? 0
                if dateDiff == 1 {
                    currentStreak += 1
                } else {
                    // Reset current streak if there's a gap of more than one day
                    currentStreak = 1
                }
            } else {
                // Start the streak if this is the first mood entry
                currentStreak = 1
            }

            lastDate = mood.date
            bestStreak = max(bestStreak, currentStreak)
        }

        // Adjust the current streak based on the date of the last logged mood
        if let lastMoodDate = sortedMoods.last?.date {
            if calendar.isDateInToday(lastMoodDate) {
                // Current streak remains as calculated if the last mood was logged today
            } else if calendar.isDateInYesterday(lastMoodDate) {
                // Current streak remains as calculated if the last mood was logged yesterday
            } else {
                // Reset current streak to 0 if there's a gap
                currentStreak = 0
            }
        }

        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.totalDaysLogged = sortedMoods.count
    }

    // MARK: Calculate Mood count
    func calculateMoodStates() -> [String: Int] {
        var moodStatesCount = [String: Int]()
        
        for mood in moods {
            for state in mood.dayStates {
                let stateKey = "\(state)" // Convert the DayState to a String
                moodStatesCount[stateKey, default: 0] += 1
            }
        }
        
        return moodStatesCount
    }
}
