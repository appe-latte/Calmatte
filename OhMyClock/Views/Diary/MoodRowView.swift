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
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(mood.emotion.moodColor)
                    .frame(maxWidth: width * 0.25, maxHeight: height * 0.15)
                    .overlay {
                        VStack(alignment: .center, spacing: 20) {
                            moodImage()
                                .scaledToFit()
                                .frame(maxWidth: 120)
                            
                            Text(mood.dayStates.map { $0.rawValue }.joined(separator: ", "))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(np_white)
                        }
                    }
                
                Spacer()
                
                // MARK: Summary
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        
                        HStack {
                            Text(mood.monthString)
                            
                            Text("\(mood.dayAsInt),")
                            
                            Text("\(mood.year)")
                        }
                    }
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundColor(np_gray)
                    .padding(.vertical, 5)
                    
                    HStack {
                        Text("How did you feel?")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(np_gray)
                        
                        Spacer()
                    }
                    
                    // MARK: Summary
                    HStack {
                        Text(mood.comment ?? "No Summary")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(7)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(np_white)
                            .minimumScaleFactor(0.75)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: width * 0.7, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
        return Image(imageName).resizable().frame(width: 60, height: 60)
    }
}
