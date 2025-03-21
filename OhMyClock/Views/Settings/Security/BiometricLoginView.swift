//
//  BiometricLoginView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import Foundation
import SwiftUI
import LocalAuthentication

struct BiometricLoginView: View {
    @ObservedObject var appLockViewModel: AppLockViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        ZStack {
            background()
            
            VStack(alignment: .center) {
                Spacer()
                
                VStack(spacing: 15) {
                    Image("face-id")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(np_white)
                    
                    Text("Unlock to proceed")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .kerning(2)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                        .padding(5)
                }
                
                Spacer()
                
                HStack {
                    
                    // MARK: Logout Button
                    Button(action: {
                        authViewModel.signOut()
                    }, label: {
                        HStack {
                            Image("logout")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text("Logout")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                    })
                    
                    Spacer()
                    
                    // MARK: Unlock with Face ID
                    Button(action: {
                        appLockViewModel.appLockValidation()
                    }, label: {
                        HStack {
                            Image("unlock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text("Unlock")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                    })
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear(perform: appLockViewModel.appLockValidation) // This will call the authentication immediately when this view appears.
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
                .fill(np_arsenic)
//                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}
