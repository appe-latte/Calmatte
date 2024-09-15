//
//  ProgressLoadingView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import Foundation
import SwiftUI

struct ProgressLoadingView: View {
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            background()
                .edgesIgnoringSafeArea(.all)
            
            LottieAnimView(animationFileName: "loading", loopMode: .loop)
                .aspectRatio(contentMode: .fit)
                .frame(width: width - 50)
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
//            Image("img-bg")
//                .resizable()
//                .scaledToFill()
//                .frame(height: size.height, alignment: .bottom)
            
            Rectangle()
                .fill(np_jap_indigo)
//                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}
