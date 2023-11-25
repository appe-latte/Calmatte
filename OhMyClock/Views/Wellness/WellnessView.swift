//
//  WellnessView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-25.
//

import SwiftUI

struct WellnessView: View {
    @State private var showPlayer = false
    @State private var wellnessDescription = "Take a moment to pause, take some deep breathes, reflect and centre your mind."
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Background
            background()
            
            VStack {
                HeaderView()
                
                Spacer()
                
                // MARK: User Subscription Status
                //            VStack {
                //                HStack {
                //                    Image("paid")
                //                        .resizable()
                //                        .frame(width: 25, height: 25)
                //                        .padding(5)
                //                        .foregroundColor(np_turq)
                //
                //                    Text("Subscription:")
                //                        .font(.caption2)
                //                        .fontWeight(.semibold)
                //                        .kerning(2)
                //                        .textCase(.uppercase)
                //                        .foregroundColor(np_white)
                //
                //                    Text(userViewModel.isSubscriptionActive ? "Calmatte Plus" : "Free")
                //                        .font(.caption2)
                //                        .fontWeight(.semibold)
                //                        .kerning(2)
                //                        .textCase(.uppercase)
                //                        .foregroundColor(np_white)
                //                }
                //            }
                //            .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_arsenic)
                .frame(height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Calmatte Wellness")
                    .font(.custom("Butler", size: 27))
                    .minimumScaleFactor(0.5)
                    .foregroundColor(np_white)
                
                Spacer()
            }
            .hAlign(.leading)
            
            // MARK: Description
            Text("\(wellnessDescription)")
                .font(.custom("Butler", size: 16))
                .kerning(3)
                .minimumScaleFactor(0.5)
                .foregroundColor(np_gray)
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                np_jap_indigo
            }
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
        }
    }
}

struct WellnessView_Previews: PreviewProvider {
    static var previews: some View {
        WellnessView()
    }
}
