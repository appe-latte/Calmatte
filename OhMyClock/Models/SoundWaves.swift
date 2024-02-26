//
//  SoundWaves.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-02-26.
//

import SwiftUI
import Foundation

struct SoundWave: Shape {
    var frequency : CGFloat = 2.0
    var density : CGFloat = 1.0
    var phase : CGFloat
    var normedAmplitude : CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let maxAmplitude = rect.height / 2.0
        let mid = rect.width / 2
        
        for x in Swift.stride(from: 0, to: rect.width + self.density, by: self.density) {
            let scaling = -pow(1 / mid * (x - mid), 2) + 1
            let y = scaling + maxAmplitude * normedAmplitude * sin(CGFloat(2 * Double.pi) * self.frequency * (x / rect.width) + self.phase) + rect.height / 2
            
            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

struct Muiltiwave: View {
    var amplitude : CGFloat = 4.0
    var color : Color = np_red
    var phase : CGFloat = 0.0
    
    var body: some View {
        ZStack {
            ForEach((0...10), id: \.self) { count in
                singleWave(count: count)
            }
        }
    }
    
    func singleWave(count: Int) -> some View {
        let progress = 1.0 - CGFloat(count) / CGFloat(5)
        let normedAmplitude = (1.5 * progress  - 0.8) * self.amplitude
        let alphaComponent = min(1.0, (progress / 3.0 * 2.0) + (1.0 / 3.0))
        
        return SoundWave(phase: phase, normedAmplitude: normedAmplitude)
            .stroke(color.opacity(Double(alphaComponent)), lineWidth: 1.0 / CGFloat(count + 1))
    }
}
