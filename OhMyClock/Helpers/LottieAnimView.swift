//
//  LottieAnimView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2025-03-16.
//
import Lottie
import SwiftUI

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

struct LottieIconAnimView: UIViewRepresentable {
    var animationFileName: String
    let loopMode: LottieLoopMode

    // Add height and width parameters
    var height: CGFloat
    var width: CGFloat

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Update the frame of the animation view if needed
        if let animationView = uiView.subviews.first as? LottieAnimationView {
            animationView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: CGRect.zero)
        let animationView = LottieAnimationView(name: animationFileName)

        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFit

        // Add the animation view as a subview
        view.addSubview(animationView)

        // Disable autoresizing mask and apply constraints
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: height),
            animationView.widthAnchor.constraint(equalToConstant: width),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }
}
