//
//  CalmattePaywallView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-24.
//

import SwiftUI
import RevenueCat

struct CalmattePaywallView: View {
    @Binding var showPaywall: Bool
    @State var currentOffering: Offering?
    @EnvironmentObject var userViewModel: UserViewModel
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            background()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Calmatte Plus")
                    .scaledToFill()
                    .font(.custom("Butler", size: 27))
                    .fontWeight(.heavy)
                    .kerning(5)
                    .minimumScaleFactor(0.5)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                
                Text("Unlock Mood Reports and Wellness AI")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .kerning(3)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                
                Spacer()
                    .frame(height: 20)
                
                VStack(alignment: .leading, spacing: 40) {
                    // MARK: AI Mood Analysis
                    HStack {
                        Image("zen")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("Engage with our AI to understand your moods deeply. Get personalized suggestions and insights based on your mood journal entries.")
                    }
                    
                    // MARK: AI Reports & Trends
                    HStack {
                        Image("zen")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("Gain deeper insights into your emotional trends and habit development with comprehensive AI-analyzed reports.")
                    }
                    
                    // MARK: Audio -- Meditation
                    HStack {
                        Image("zen")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("Relax and meditate with a variety of calming sounds and guided sessions, now enhanced with AI recommendations based on your mood and habits.")
                    }
                }
                .font(.caption)
                .fontWeight(.medium)
                .kerning(1)
                .foregroundColor(np_white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                
                Spacer()
                
                if currentOffering != nil {
                    ForEach(currentOffering!.availablePackages) { pkg in
                        Button {
                            Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
                                if customerInfo?.entitlements.all["calm_plus"]?.isActive == true {
                                    userViewModel.isSubscriptionActive = true
                                    showPaywall = false
                                }
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: width - 40, height: 35)
                                    .background(np_white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Text("\(pkg.storeProduct.localizedTitle) \(pkg.storeProduct.localizedPriceString)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                Text("Embrace a more mindful, balanced life with Calmatte. Subscribe today and experience the synergy of AI and mindfulness, redefining your path to wellness and personal growth!")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .kerning(1)
                    .foregroundColor(np_white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(30)
        }
        .onAppear {
            Purchases.shared.getOfferings { offerings, error in
                if let offer = offerings?.current, error == nil {
                    currentOffering = offer
                }
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

struct CalmattePaywallView_Previews: PreviewProvider {
    static var previews: some View {
        CalmattePaywallView(showPaywall: .constant(false))
    }
}
