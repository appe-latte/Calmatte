//
//  MeditationViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import Foundation

final class MeditationViewModel : ObservableObject {
    private(set) var meditation : Meditation
    
    init(meditation: Meditation) {
        self.meditation = meditation
    }
}

struct Meditation {
    let id = UUID()
    let title : String
    let description : String
    let duration : TimeInterval
    let track : String
    let image : String
    
    static let data = Meditation(title: "7-Minute Meditation", description: "Take a moment to pause, breathe deeply, and bring a sense of calm to your mind and body to help you refocus and feel refreshed.", duration: 420, track: "equilibrium", image: "meditation-stones")
}
