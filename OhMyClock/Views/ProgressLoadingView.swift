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
            np_jap_indigo.edgesIgnoringSafeArea(.all)
            
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: np_white))
                .frame(width: 100, height: 100)
                .background(np_arsenic)
                .foregroundColor(np_white)
                .cornerRadius(10)
        }
    }
}
