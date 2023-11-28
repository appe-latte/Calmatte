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
            
//            ProgressView("Loading")
//                .progressViewStyle(CircularProgressViewStyle(tint: np_white))
//                .frame(width: 150, height: 125)
//                .background(np_arsenic)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//                .font(.subheadline)
//                .fontWeight(.semibold)
//                .kerning(3)
//                .textCase(.uppercase)
//                .foregroundColor(np_white)
            
            LottieAnimView(animationFileName: "loading", loopMode: .loop)
                .aspectRatio(contentMode: .fit)
                .frame(width: width - 50)
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(np_jap_indigo)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}
