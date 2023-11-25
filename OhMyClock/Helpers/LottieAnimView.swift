//
//  LottieAnimView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-25.
//

import SwiftUI
import Lottie

struct LottieAnimView: UIViewRepresentable {
    var animationFileName: String
    let loopMode: LottieLoopMode
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
    
    func makeUIView(context: Context) -> some Lottie.LottieAnimationView {
        let view = UIView()
        let animationView = LottieAnimationView(name: animationFileName)
        
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFit
        
        return animationView
    }
}
