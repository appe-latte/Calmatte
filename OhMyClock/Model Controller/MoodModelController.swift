//
//  MoodModelController.swift
//  OhMyClock
//
//  Created by Nelson Gonzalez on 3/27/20.
//  Modified by Stanford L. Khumalo on 2023-07-11.
//

import Foundation
import Combine

class MoodModelController: ObservableObject {
    
    //MARK: - Properties
    @Published var moods: [Mood] = []
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var totalDaysLogged: Int = 0
        
    init() {
        loadFromPersistentStore()
    }
    
    //MARK: - CRUD Functions -- Mood Journal
    func createMood(emotion: Emotion, comment: String?, date: Date, dayStates: [DayState]) {

        let newMood = Mood(emotion: emotion, comment: comment, date: date, dayStates: dayStates)
        
        moods.append(newMood)
        saveToPersistentStore()
        calculateStreaks()
    }
    
    // MARK: "Delete" mood
    func deleteMood(at offset: IndexSet) {
        guard let index = Array(offset).first else { return }
        print("INDEX: \(index)")
        moods.remove(at: index)
        
        saveToPersistentStore()
        calculateStreaks()
    }

    // MARK: "Update"
    func updateMoodComment(mood: Mood, comment: String) {
        if let index = moods.firstIndex(of: mood) {
            var mood = moods[index]
            mood.comment = comment
            
            moods[index] = mood
            saveToPersistentStore()
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
    
    func saveToPersistentStore() {
        
        // Stars -> Data -> Plist
        guard let url = persistentFileURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(moods)
            try data.write(to: url)
        } catch {
            print("Error saving stars data: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        
        // Plist -> Data -> Stars
        let fileManager = FileManager.default
        guard let url = persistentFileURL, fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            moods = try decoder.decode([Mood].self, from: data)
            calculateStreaks()
        } catch {
            print("error loading stars data: \(error)")
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
            
            if Calendar.current.isDateInYesterday(mood.date) {
                currentStreak += 1
                if currentStreak > bestStreak {
                    bestStreak = currentStreak
                }
            } else {
                currentStreak = 1
            }
            
            lastDate = mood.date
        }
        
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.totalDaysLogged = sortedMoods.count
    }
}
