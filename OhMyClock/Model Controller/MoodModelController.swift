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
    
    //MARK: - CRUD Functions -- Mood Journal
    func createMood(emotion: Emotion, comment: String?, date: Date, dayStates: [DayState]) {

        let newMood = Mood(emotion: emotion, comment: comment, date: date, dayStates: dayStates)
        
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

    // MARK: "Update"
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
    
//    func asDictionary() throws -> [String: Any] {
//        let data = try JSONEncoder().encode(self)
//        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
//            throw NSError()
//        }
//        return dictionary
//    }
    
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
        
        let sortedMoods = moods.sorted(by: { $0.date < $1.date })
        var currentStreak = 1
        var bestStreak = 1
        var lastDate: Date? = sortedMoods.first?.date
        
        for mood in sortedMoods.dropFirst() {
            if Calendar.current.isDate(mood.date, inSameDayAs: lastDate!) {
                continue // Skip this iteration if the mood was logged on the same day
            }
            
            let dateDiff = Calendar.current.dateComponents([.day], from: lastDate!, to: mood.date).day ?? 0
            
            if dateDiff == 1 {
                // the mood is logged the next day
                currentStreak += 1
            } else if dateDiff > 1 {
                // the mood is logged after skipping one or more days
                currentStreak = 1
            }
            
            if currentStreak > bestStreak {
                bestStreak = currentStreak
            }
            
            lastDate = mood.date
        }

        // After going through all moods, we need to check if the last mood's date is yesterday or today
        if let lastDate = lastDate,
           !Calendar.current.isDateInToday(lastDate),
           !Calendar.current.isDateInYesterday(lastDate) {
            currentStreak = 0
        }

        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.totalDaysLogged = sortedMoods.count
    }
}
