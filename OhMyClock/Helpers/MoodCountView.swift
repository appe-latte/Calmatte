//
//  MoodCountView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-20.
//

import SwiftUI

struct MoodCountView: View {
    struct MoodDataModel: Identifiable {
        var id = UUID()
        var emotion: String
        var count: Double
        var color: Color
    }
    
    @ObservedObject var moodCount: DayStateViewModel = DayStateViewModel()
    
    // Initialize moodData with counts from moodCount
    private func initializeMoodData() -> [MoodDataModel] {
        return [
            .init(emotion: "Amazing", count: Double(moodCount.frequency(for: .amazing)), color: np_green),
            .init(emotion: "Good", count: Double(moodCount.frequency(for: .good)), color: np_turq),
            .init(emotion: "Okay", count: Double(moodCount.frequency(for: .okay)), color: np_yellow),
            .init(emotion: "Bad", count: Double(moodCount.frequency(for: .bad)), color: np_orange),
            .init(emotion: "Terrible", count: Double(moodCount.frequency(for: .terrible)), color: np_red),
            .init(emotion: "Meh", count: Double(moodCount.frequency(for: .meh)), color: np_purple)
        ]
    }
    
    // Use a computed property to get the mood data with updated counts
    private var moodData: [MoodDataModel] {
        initializeMoodData()
    }
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Label("Mood Cards:", systemImage: "")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // MARK: Row One
                HStack(spacing: 20) {
                    // "Amazing" Count
                    RoundedRectangle(cornerRadius: 15)
                        .fill(np_green.opacity(0.1))
                        .frame(width: 150, height: 175)
                        .overlay {
                            VStack(spacing: 20) {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .fill(np_green)
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        Text("\(moodCount.frequency(for: .amazing))")
                                            .font(.system(size: 15, weight: .heavy))
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                    }
                                
                                Text("Amazing")
                                    .font(.system(size: 10, weight: .bold))
                                    .textCase(.uppercase)
                                    .kerning(3)
                                    .foregroundColor(np_white)
                            }
                        }
                    
                    // "Good" Count
                    RoundedRectangle(cornerRadius: 15)
                        .fill(np_turq.opacity(0.1))
                        .frame(width: 150, height: 175)
                        .overlay {
                            VStack(spacing: 20) {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .fill(np_turq)
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        Text("\(moodCount.frequency(for: .good))")
                                            .font(.system(size: 15, weight: .heavy))
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                    }
                                
                                Text("Good")
                                    .font(.system(size: 10, weight: .bold))
                                    .textCase(.uppercase)
                                    .kerning(3)
                                    .foregroundColor(np_white)
                            }
                        }
                }
                
                // MARK: Row Two
                HStack(spacing: 20) {
                    // "Okay" Count
                    RoundedRectangle(cornerRadius: 15)
                        .fill(np_yellow.opacity(0.1))
                        .frame(width: 150, height: 175)
                        .overlay {
                            VStack(spacing: 20) {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .fill(np_yellow)
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        Text("\(moodCount.frequency(for: .okay))")
                                            .font(.system(size: 15, weight: .heavy))
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                    }
                                
                                Text("Okay")
                                    .font(.system(size: 10, weight: .bold))
                                    .textCase(.uppercase)
                                    .kerning(3)
                                    .foregroundColor(np_white)
                            }
                        }
                    
                    // "Meh" Count
                    RoundedRectangle(cornerRadius: 15)
                        .fill(np_purple.opacity(0.1))
                        .frame(width: 150, height: 175)
                        .overlay {
                            VStack(spacing: 20) {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .fill(np_purple)
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        Text("\(moodCount.frequency(for: .meh))")
                                            .font(.system(size: 15, weight: .heavy))
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                    }
                                
                                Text("Meh")
                                    .font(.system(size: 10, weight: .bold))
                                    .textCase(.uppercase)
                                    .kerning(3)
                                    .foregroundColor(np_white)
                            }
                        }
                }
                
                // MARK: Row Three
                HStack(spacing: 20) {
                    // "Bad" Count
                    RoundedRectangle(cornerRadius: 15)
                        .fill(np_orange.opacity(0.1))
                        .frame(width: 150, height: 175)
                        .overlay {
                            VStack(spacing: 20) {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .fill(np_orange)
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        Text("\(moodCount.frequency(for: .bad))")
                                            .font(.system(size: 15, weight: .heavy))
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                    }
                                
                                Text("Bad")
                                    .font(.system(size: 10, weight: .bold))
                                    .textCase(.uppercase)
                                    .kerning(3)
                                    .foregroundColor(np_white)
                            }
                        }
                    
                    // "Terrible" Count
                    RoundedRectangle(cornerRadius: 15)
                        .fill(np_red.opacity(0.1))
                        .frame(width: 150, height: 175)
                        .overlay {
                            VStack(spacing: 20) {
                                Circle()
                                    .stroke(lineWidth: 15)
                                    .fill(np_red)
                                    .frame(width: 100, height: 100)
                                    .overlay {
                                        Text("\(moodCount.frequency(for: .terrible))")
                                            .font(.system(size: 15, weight: .heavy))
                                            .textCase(.uppercase)
                                            .foregroundColor(np_white)
                                    }
                                
                                Text("Terrible")
                                    .font(.system(size: 10, weight: .bold))
                                    .textCase(.uppercase)
                                    .kerning(3)
                                    .foregroundColor(np_white)
                            }
                        }
                }
            }
        }
    }
}
