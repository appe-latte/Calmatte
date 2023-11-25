//
//  LottieViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-25.
//

import SwiftUI
import Lottie
import Foundation

struct LottieViewModel: UIViewRepresentable {
    var animationFileName: String
    let loopMode: LottieLoopMode
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
    
    func makeUIView(context: Context) -> some Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFill
        return animationView
    }
}
