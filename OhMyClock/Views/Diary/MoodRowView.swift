//
//  MoodRowView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import SwiftUI
import Foundation

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
                        .font(.headline)
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_black)
                    
                    ZStack {
                        Circle()
                            .fill(np_arsenic)
                            .frame(width: 40, height: 40)
                        
                        Text("\(mood.dayAsInt)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                    }
                    
                }
                
                Text(mood.comment ?? "No Summary")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .textCase(.uppercase)
                    .foregroundColor(np_black)
                
                Spacer()
                
                // MARK: Mood Image + Text
                VStack(spacing: 5) {
                    moodImage()
                    
//                    Text(mood.emotion.state.rawValue)
//                        .font(.system(size: 10))
//                        .fontWeight(.regular)
//                        .textCase(.uppercase)
//                        .foregroundColor(np_black)
                    
                    Text(mood.dayStates.map { $0.rawValue }.joined(separator: ", "))
                        .font(.system(size: 10))
                        .fontWeight(.regular)
                        .textCase(.uppercase)
                        .foregroundColor(np_black)
                }
            }
            .padding(5)
        }
    }
    
    func moodImage() -> some View {
        var imageName = "none"
        
        switch mood.emotion.state {
        case .great:
            imageName = "great"
        case .good:
            imageName = "good"
        case .okay:
            imageName = "okay"
        case .upset:
            imageName = "upset"
        case .angry:
            imageName = "angry"
        }
        return Image(imageName).resizable().frame(width: 30, height: 30)
    }
}
