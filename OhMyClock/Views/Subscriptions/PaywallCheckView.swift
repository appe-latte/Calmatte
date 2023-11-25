//
//  PaywallCheckView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-24.
//

import SwiftUI
import RevenueCat

struct PaywallCheckView: View {
    @State var showPaywall = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            background()
            
            VStack(alignment: .center, spacing: 10) {
                Text("Calmatte Plus")
                    .scaledToFill()
                    .font(.custom("Butler", size: 27))
                    .fontWeight(.heavy)
                    .kerning(5)
                    .minimumScaleFactor(0.5)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                
                Text("Unlock Mood Reports and Wellness AI")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .kerning(3)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                
                Spacer()
                
                VStack(spacing: 15) {
                   // MARK: Subscription Button
                    Button {
                        showPaywall = true
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: width - 40, height: 35)
                                .background(np_white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("Subscribe to Calmatte PLus")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_jap_indigo)
                        }
                    }
                   
                   // MARK: Restore Subscription Button
                   Button {
                       Purchases.shared.restorePurchases { (customerInfo, error) in
                           userViewModel.isSubscriptionActive = customerInfo?.entitlements.all["calm_plus"]?.isActive == true
                       }
                   } label: {
                       ZStack {
                           
                           Text("Restore Subscription")
                               .font(.caption2)
                               .fontWeight(.semibold)
                               .kerning(2)
                               .textCase(.uppercase)
                               .foregroundColor(np_white)
                       }
                   }
                }
            }
            .padding()
            // Displays Paywall if not subscribed
            if showPaywall {
                CalmattePaywallView(showPaywall: $showPaywall)
            }
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

struct PaywallCheckView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallCheckView()
    }
}

