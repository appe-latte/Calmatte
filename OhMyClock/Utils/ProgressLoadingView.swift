//
//  ProgressLoadingView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import Foundation
import SwiftUI


struct ProgressLoadingView: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
            }.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 1){
                ProgressView()
                    .frame(width: 60, height: 60)
                    .progressViewStyle(CircularProgressViewStyle(tint: np_turq))
                    .scaleEffect(2)
                
                Text("Please Wait")
                    .foregroundColor(np_green)
                    .font(.custom("Avenir", size: 12).bold())
            }
            .frame(width: 80, height: 100)
            .background(np_white)
            .cornerRadius(10)
        }
    }
}
