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
            VStack(spacing: 15){
                // MARK: Date
                HStack {
                    Spacer()
                    
                    HStack {
                        Text(mood.monthString)
                        
                        Text("\(mood.dayAsInt),")
                        
                        Text("\(mood.year)")
                    }
                }
                .font(.caption2)
                .fontWeight(.heavy)
                .kerning(2)
                .textCase(.uppercase)
                .foregroundColor(np_white)
                
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: width - 20, height: height * 0.2)
                    .background(np_white).opacity(0.05)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        // MARK: Mood Info
                        HStack(spacing: 10) {
                            VStack(spacing: 20) {
                                moodImage()
                                    .frame(width: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .scaledToFit()
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(np_white, lineWidth: 1))
                                
                                Text(mood.emotion.state.rawValue)
                                    .font(.caption2)
                                    .fontWeight(.heavy)
                                    .kerning(2)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                            }
                            
                            Divider()
                                .background(np_gray)
                            
                            Spacer()
                            
                            // MARK: Summary
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("How did you feel?")
                                        .font(.system(size: 17))
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(mood.comment ?? "No Summary")
                                        .font(.system(size: 14))
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
                        .padding(10)
                    }
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
