//
//  OhMyClockApp.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import SwiftUI

@main
struct OhMyClockApp: App {
    @StateObject var audioManager = AudioManager()
    @StateObject var timerModel: TimerModel = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioManager)
                .environmentObject(timerModel)
//                .preferredColorScheme(.light)
        }
    }
}
