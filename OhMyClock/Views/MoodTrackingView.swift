//
//  MoodTrackingView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-27.
//

import SwiftUI
import CoreData

struct MoodTrackingView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: MoodEntity.fetchRequest()) var moodEntities: FetchedResults<MoodEntity>

    @AppStorage("currentMood") private var currentMood: Mood.RawValue = Mood.neutral.rawValue
    
    let moods: [Mood] = [.happy, .sad, .angry, .neutral, .anxious]

    var body: some View {
        VStack {
            ForEach(moods, id: \.self) { mood in
                Button(action: {
                    currentMood = mood.rawValue
                    addMoodRecord(mood)
                }) {
                    Text(mood.rawValue.capitalized)
                }
                .padding()
                .background(Mood(rawValue: currentMood) == mood ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            List(moodRecords, id: \.self) { moodRecord in
                VStack(alignment: .leading) {
                    Text(moodRecord.mood.rawValue.capitalized)
                    Text(moodRecord.date, formatter: itemFormatter)
                }
            }
        }
        .padding()
    }
    
    var moodRecords: [MoodRecord] {
        let sortedMoodEntities = moodEntities.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
        return Array(sortedMoodEntities.compactMap(MoodRecord.init).prefix(7))
    }
    
    private func addMoodRecord(_ mood: Mood) {
        let moodEntity = MoodEntity(context: managedObjectContext)
        moodEntity.mood = mood.rawValue
        moodEntity.date = Date()
        
        do {
            try managedObjectContext.save()
        } catch {
            // Handle the Core Data error
            print(error.localizedDescription)
        }
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

enum Mood: String, CaseIterable {
    case happy
    case sad
    case angry
    case neutral
    case anxious
}

struct MoodTrackingView_Previews : PreviewProvider {
    static var previews : some View {
        MoodTrackingView()
    }
}
