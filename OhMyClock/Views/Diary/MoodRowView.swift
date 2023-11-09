//
//  MoodRowView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore

struct MoodRowView: View {
    var mood: Mood
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // MARK: Date
                HStack {
                    Spacer()
                    
                    HStack {
                        Text(mood.monthString)
                        
                        Text("\(mood.dayAsInt),")
                        
                        Text("\(mood.year)")
                    }
                    .frame(maxWidth: 100, maxHeight:20)
                    .background(np_white)
                    .clipShape(Capsule())
                }
                .font(.caption2)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .foregroundColor(np_jap_indigo)
                
                HStack(alignment: .top, spacing: 10) {
                    // MARK: Emotion
                    VStack(spacing: 5) {
                        moodImage()
                            .scaledToFit()
                            .frame(maxWidth: 90)
                            .clipShape(Circle())
                        
                        Rectangle()
                            .fill(mood.emotion.moodColor)
                            .frame(width: 2)
                            .edgesIgnoringSafeArea(.all)
                        
                        Circle()
                            .fill(mood.emotion.moodColor)
                            .frame(width: 10, height: 10)
                        
                        Text(mood.dayStates.map { $0.rawValue }.joined(separator: ", "))
                            .font(.system(size: 8))
                            .fontWeight(.semibold)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(np_white)
                    }
                    .frame(maxWidth: 125)
                    .padding(5)
                    
                    
                    // MARK: Summary
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(mood.comment ?? "No Summary")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(7)
                                .multilineTextAlignment(.leading)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                .minimumScaleFactor(0.75)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .frame(width: width * 0.6, height: 150)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(5)
        }
    }
    
    func moodImage() -> some View {
        var imageName = "none"
        
        switch mood.emotion.state {
        case .happy:
            imageName = "happy"
        case .sad:
            imageName = "sad"
        case .cheeky:
            imageName = "cheeky"
        case .upset:
            imageName = "upset"
        case .angry:
            imageName = "angry"
        case .sleepy:
            imageName = "sleepy"
        case .loved:
            imageName = "loved"
        case .meh:
            imageName = "meh"
        case .sick:
            imageName = "sick"
        case .smiling:
            imageName = "smiling"
        }
        return Image(imageName).resizable().frame(width: 30, height: 30)
    }
}
