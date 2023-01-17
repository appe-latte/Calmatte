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
    
    static let data = Meditation(title: "5-Minute Meditation", description: "Take a deep breath, close your eyes, relax and take this quick 5-minute meditation break to help you refocus.", duration: 300, track: "equilibrium", image: "meditation-stones")
}
