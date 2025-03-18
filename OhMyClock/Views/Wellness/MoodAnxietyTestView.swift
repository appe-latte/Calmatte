//
//  MoodAnxietyTestView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2025-03-10.
//

import SwiftUI

struct MoodAnxietyTestView: View {
    @State private var answers: [Int?] = Array(repeating: nil, count: 7)
    @State private var score: Int? = nil
    @State private var moodLevel: MoodLevel? = nil
    @State private var testDate: Date? = nil
    
    @State private var showResult = false
    
    var width = UIScreen.main.bounds.width
    
    let questions = [
        "Feeling nervous, anxious or on edge",
        "Not being able to stop or control worrying",
        "Worrying too much about different things",
        "Trouble relaxing",
        "Being so restless that it's hard to sit still",
        "Becoming easily annoyed or irritable",
        "Feeling afraid as if something awful might happen"
    ]
    
    let answerOptions = [
        "Not at all",
        "Several days",
        "More than half the days",
        "Nearly every day"
    ]
    
    enum MoodLevel: String {
        case good = "good"
        case mild = "mild"
        case moderate = "moderate"
        case severe = "severe"
        
        var color: Color {
            switch self {
            case .good: return .green
            case .mild: return .yellow
            case .moderate: return .orange
            case .severe: return .red
            }
        }
        
        var description: String {
            switch self {
            case .good: return "Minimal Anxiety"
            case .mild: return "Mild Anxiety"
            case .moderate: return "Moderate Anxiety"
            case .severe: return "Severe Anxiety"
            }
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Wellness Assessment")
                .font(.custom("Butler", size: 30))
                .foregroundStyle(np_light_gray)
                .minimumScaleFactor(0.5))
            {
                Text("Over the last 2 weeks, how often have you been bothered by the following problems?")
                    .font(.system(size: 12, weight: .bold))
                    .textCase(.uppercase)
                    .kerning(1)
                    .foregroundStyle(np_white)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                
                ForEach(0..<questions.count, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text("\(index + 1). \(questions[index])")
                            .font(.system(size: 14, weight: .heavy))
                            .textCase(.uppercase)
                            .foregroundStyle(np_white)
                            .kerning(1)
                            .padding(.vertical, 5)
                        
                        VStack(alignment:.leading) {
                            ForEach(0..<answerOptions.count, id: \.self) { answerIndex in
                                HStack {
                                    RadioButton(isSelected: Binding(
                                        get: { answers[index] == answerIndex },
                                        set: { newValue in
                                            answers[index] = newValue ? answerIndex : nil
                                        }
                                    ))
                                    
                                    Text(answerOptions[answerIndex])
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .textCase(.uppercase)
                                        .foregroundStyle(np_white)
                                        .kerning(1)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(alignment: .top)
                            }
                        }
                    }
                    .padding(.bottom)
                }
                
                // MARK: Questionaire Submission Button
                Button {
                    calculateScoreAndMood()
                    saveResult()
                    showResult = true
                } label: {
                    VStack(alignment: .center) {
                        Text("Submit Results")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                    }
                }
                .frame(width: 300, height: 45)
                .background(np_white)
                .foregroundColor(np_jap_indigo)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(answers.contains(nil) ? 0.1 : 1)
            }
            .listRowBackground(np_arsenic)
            
            if showResult {
                Section(header: Text("Test Result").font(.custom("Butler", size: 20)).foregroundStyle(np_white)) {
                    if let moodLevel = moodLevel, let score = score, let testDate = testDate {
                        HStack {
                            Text("Total Score:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                                .kerning(1)
                                .foregroundStyle(np_jap_indigo)
                            
                            Spacer()
                            
                            Text("\(score)")
                                .font(.custom("Butler", size: 30))
                                .foregroundStyle(np_jap_indigo)
                        }
                        
                        HStack {
                            Text("Anxiety Level:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                                .kerning(1)
                                .foregroundStyle(np_jap_indigo)
                            
                            Spacer()
                            
                            Circle() // Mood Level Colour for visual representation
                                .fill(moodLevel.color)
                                .frame(width: 15)
                                .clipShape(Circle())
                            
                            Text("\(moodLevel)")
                                .font(.custom("Butler", size: 20))
                                .foregroundStyle(np_jap_indigo)
                        }
                    } else {
                        Text("Error calculating result.")
                    }
                }
                .listRowBackground(np_gray)
            }
        }
        .scrollContentBackground(.hidden)
        .background(np_arsenic)
        .onAppear {
            loadResult() // Load previous result when view appears
        }
    }
    
    func calculateScoreAndMood() {
        let calculatedScore = answers.compactMap { $0 }.reduce(0, +)
        score = calculatedScore
        testDate = Date() // Record current date and time
        
        switch calculatedScore {
        case 0...4: moodLevel = .good
        case 5...9: moodLevel = .mild
        case 10...14: moodLevel = .moderate
        case 15...21: moodLevel = .severe
        default: moodLevel = .mild // Default case, should not be reached in GAD-7 scoring
        }
    }
    
    func saveResult() {
        guard let score = score, let moodLevel = moodLevel, let testDate = testDate else { return }
        UserDefaults.standard.set(score, forKey: "GAD7Score")
        UserDefaults.standard.set(moodLevel.rawValue, forKey: "GAD7MoodLevel") // Now rawValue is available
        UserDefaults.standard.set(testDate, forKey: "GAD7TestDate")
    }
    
    func loadResult() {
        score = UserDefaults.standard.object(forKey: "GAD7Score") as? Int
        if let moodLevelString = UserDefaults.standard.string(forKey: "GAD7MoodLevel") {
            moodLevel = MoodLevel(rawValue: moodLevelString) // Initialize from rawValue string
        }
        testDate = UserDefaults.standard.object(forKey: "GAD7TestDate") as? Date
        if score != nil {
            showResult = true // Automatically show result if there's a saved score
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

struct RadioButton: View {
    @Binding var isSelected: Bool
    
    var body: some View {
        Button(action: {
            self.isSelected.toggle()
        }) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 15, height: 15)
                    .overlay(Circle().stroke(np_arsenic, lineWidth: 1))
                if isSelected {
                    Circle()
                        .fill(np_jap_indigo)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(np_white, lineWidth: 1))
                }
            }
        }
        .buttonStyle(BorderedButtonStyle())
        .background(np_gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    MoodAnxietyTestView()
}
