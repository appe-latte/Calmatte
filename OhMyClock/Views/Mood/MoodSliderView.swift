//
//  MoodSliderView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-29.
//
import SwiftUI

struct MoodSliderView: View {
    private let sliderDotSize: CGFloat = 35
    private let hapticFeedback = UIImpactFeedbackGenerator()
    @State var didChangeDefaultMoodType: Bool = false
    @State var sliderValue: CGFloat = 45

    var model: MoodModel
    
    func sliderValue(forMood type: MoodType) -> CGFloat {
        let level = UIScreen.main.bounds.width / 9
        switch type {
        case .angry:
            return 45
        case .upset:
            return (level * 3) - 8
        case .okay:
            return (level * 5) - 22
        case .good:
            return (level * 7) - 35
        case .great:
            return (level * 9) - 48
        }
    }
    
    var body: some View {
        let xPosition: CGFloat = -(UIScreen.main.bounds.width) / 2
        let level = UIScreen.main.bounds.width / 9
        let moodSliderValue = didChangeDefaultMoodType ? sliderValue : sliderValue(forMood: model.moodType)
        
        var offset: CGFloat = 0
        if #available(iOS 16.0, *) {
            offset = UIScreen.main.bounds.width/2
        }
        
        return
        // MARK: Progress Bar
        ZStack {
            Capsule()
                .foregroundColor(np_gray)
                .opacity(0.2)
                .frame(height: 10) // this is the track
            
            Capsule()
                .foregroundColor(np_white)
                .frame(width: moodSliderValue, height: 10) // this is the progress
                .alignmentGuide(.leading) { d in d[.leading] }
            
            // MARK: Slider Knob
            Circle()
                .foregroundColor(np_white)
                .shadow(radius: 2)
                .offset(x: xPosition + moodSliderValue, y: 0)
                .frame(height: self.sliderDotSize)
                .gesture(DragGesture(minimumDistance: 1).onChanged({ (value) in
                    self.didChangeDefaultMoodType = true
                    self.sliderValue = CGFloat(value.location.x) + offset
                    MoodType.allCases.forEach { (mood) in
                        if self.sliderValue(forMood: mood)...self.sliderValue(forMood: mood)+4 ~= self.sliderValue {
                            self.hapticFeedback.impactOccurred()
                        }
                    }
                }).onEnded({ (value) in
                    self.hapticFeedback.impactOccurred()
                    let endedValue = value.location.x + offset
                    if endedValue < level {
                        self.sliderValue = 45
                        self.model.moodType = .angry
                    } else if endedValue > level && endedValue < level * 3 {
                        if endedValue - level < ((level * 3) - endedValue) {
                            self.sliderValue = self.sliderValue(forMood: .angry)
                            self.model.moodType = .angry
                        } else {
                            self.sliderValue = self.sliderValue(forMood: .upset)
                            self.model.moodType = .upset
                        }
                    } else if endedValue > (level * 3) && endedValue < (level * 5) {
                        if endedValue - (level * 3) < ((level * 5) - endedValue) {
                            self.sliderValue = self.sliderValue(forMood: .upset)
                            self.model.moodType = .upset
                        } else {
                            self.sliderValue = self.sliderValue(forMood: .okay)
                            self.model.moodType = .okay
                        }
                    } else if endedValue > (level * 5) && endedValue < (level * 7) {
                        if endedValue - (level * 5) < ((level * 7) - endedValue) {
                            self.sliderValue = self.sliderValue(forMood: .okay)
                            self.model.moodType = .okay
                        } else {
                            self.sliderValue = self.sliderValue(forMood: .good)
                            self.model.moodType = .good
                        }
                    } else if endedValue > (level * 7) && endedValue < (level * 9) {
                        if endedValue - (level * 7) < ((level * 8) - endedValue) {
                            self.sliderValue = self.sliderValue(forMood: .good)
                            self.model.moodType = .good
                        } else {
                            self.sliderValue = self.sliderValue(forMood: .great)
                            self.model.moodType = .great
                        }
                    } else {
                        self.sliderValue = self.sliderValue(forMood: .great)
                        self.model.moodType = .great
                    }
                }))
        }
    }
}

struct MoodSliderView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSliderView(model: MoodModel())
    }
}
