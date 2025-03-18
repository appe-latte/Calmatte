//
//  MeditationView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import CoreHaptics

struct MeditationView: View {
    @StateObject var meditationViewModel: MeditationViewModel
    @State private var timeRemaining = 60
    @State private var isRunning = false
    @State private var instruction = "Inhale"
    @State private var hapticEngine: CHHapticEngine?
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            background()
            
            VStack {
                // MARK: Instructions
                Text(instruction)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(np_white)
                    .padding(.top, 20)
                
                // MARK: Expanding Circles
                BreathingCircles()
                
                // MARK: Time Remaining Counter
                Text("\(timeRemaining)s")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(np_white)
                    .padding(.bottom, 30)
                
                Spacer()
                
                HStack {
                    // MARK: Start/Stop Button
                    Button(action: {
                        if isRunning {
                            stopBreathing()
                        } else {
                            startBreathing()
                        }
                    }) {
                        Text(isRunning ? "Stop" : "Start")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(np_white)
                            .textCase(.uppercase)
                            .kerning(1)
                            .padding()
                            .background(isRunning ? np_red.opacity(0.3) : np_turq.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Spacer()
                    
                    // MARK: Haptic Feedback Toggle
                    Button(action: {
                        prepareHaptics()
                        playHapticFeedback()
                    }) {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .font(.system(size: 24))
                            .foregroundColor(np_white)
                    }
                }
                .frame(width: width - 20)
            }
            .onAppear {
                prepareHaptics()
            }
        }
    }
    
    // MARK: Background Colour
    @ViewBuilder
    func background() -> some View {
        np_arsenic
            .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: Expanding Circles
    @ViewBuilder
    func BreathingCircles() -> some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                .frame(width: 300, height: 300)
                .scaleEffect(animate ? 1 : 0.7)
                .opacity(animate ? 0 : 1)
                .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true))
            
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                .frame(width: 220, height: 220)
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 0 : 1)
                .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(1))
            
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: 4)
                .frame(width: 140, height: 140)
                .scaleEffect(animate ? 1 : 0.9)
                .opacity(animate ? 0 : 1)
                .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(2))
        }
        .onAppear {
            animate = true
        }
    }
    
    // MARK: Start/Stop Logic
    func startBreathing() {
        isRunning = true
        timeRemaining = 60
        instruction = "Inhale"
        playHapticFeedback()
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
            if !isRunning {
                timer.invalidate()
                return
            }
            
            switch instruction {
            case "Inhale":
                instruction = "Hold"
                playHapticFeedback()
            case "Hold":
                instruction = "Exhale"
                playHapticFeedback()
            case "Exhale":
                instruction = "Inhale"
                playHapticFeedback()
            default:
                break
            }
            
            if timeRemaining > 1 {
                timeRemaining -= 4
            } else {
                timer.invalidate()
                isRunning = false
            }
        }
    }
    
    func stopBreathing() {
        isRunning = false
        timeRemaining = 60
        instruction = "Inhale"
    }
    
    // MARK: Haptic Feedback
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptic Engine Error: \(error.localizedDescription)")
        }
    }
    
    func playHapticFeedback() {
        guard let hapticEngine = hapticEngine, CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        // Create haptic pattern based on instruction
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 1)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
    
    @State private var animate = false
}

struct MeditationView_Previews: PreviewProvider {
    static let meditationViewModel = MeditationViewModel(meditation: Meditation.data)
    
    static var previews: some View {
        MeditationView(meditationViewModel: meditationViewModel)
    }
}
