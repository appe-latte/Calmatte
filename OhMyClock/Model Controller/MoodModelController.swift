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
        
    init() {
        loadFromPersistentStore()
    }
    
    
    //MARK: - CRUD Functions -- Mood Journal
    func createMood(emotion: Emotion, comment: String?, date: Date, dayStates: [DayState]) {

        let newMood = Mood(emotion: emotion, comment: comment, date: date, dayStates: dayStates)
        
        moods.append(newMood)
        saveToPersistentStore()
    }
    
    func deleteMood(at offset: IndexSet) {
        
        guard let index = Array(offset).first else { return }
     print("INDEX: \(index)")
        moods.remove(at: index)
        
        saveToPersistentStore()
    }

    func updateMoodComment(mood: Mood, comment: String) {
        if let index = moods.firstIndex(of: mood) {
            var mood = moods[index]
            mood.comment = comment
            
            moods[index] = mood
            saveToPersistentStore()
        }
    }
    
    // MARK: Save, Load from Persistent
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
        } catch {
            print("error loading stars data: \(error)")
        }
    }
}

