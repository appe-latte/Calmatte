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
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(np_white)
                .cornerRadius(10)
            
            // MARK: Row Text
            HStack(spacing: 10) {
                VStack {
                    Text(mood.monthString)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_black)
                    
                    ZStack {
                        Circle()
                            .fill(mood.emotion.moodColor)
                            .frame(width: 40, height: 40)
                        
                        Text("\(mood.dayAsInt)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(mood.emotion.moodColor)
                            .frame(width: 2)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                .frame(maxWidth: 50)
                
                HStack {
                    Text(mood.comment ?? "No Summary")
                        .font(.system(size: 12))
                        .fontWeight(.regular)
                        .textCase(.uppercase)
                        .foregroundColor(np_jap_indigo)
                        .minimumScaleFactor(0.75)
                    
                    Spacer()
                }
                .frame(width: 200)
                
                Spacer()
                
                // MARK: Mood Image + Text
                VStack(spacing: 5) {
                    moodImage()
                        .scaledToFit()
                        .frame(maxWidth: 70)
                    
                    Text(mood.dayStates.map { $0.rawValue }.joined(separator: ", "))
                        .font(.system(size: 7))
                        .fontWeight(.regular)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_black)
                }
                .frame(maxWidth: 100)
            }
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
