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
                
                VStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .imageScale(.large)
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Text("Please unlock the app to continue.")
                        .font(.custom("Avenir", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(5)
                }
                
                Spacer()
                
                HStack {
                    
                    // MARK: Logout Button
                    Button(action: {
                        authViewModel.signOut()
                    },
                           label: {
                        VStack {
                            Image("turn-off-w")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(1)
                            Text("Logout")
                                .font(.custom("Avenir", size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }.padding(5)
                    })
                    
                    Spacer()
                    
                    // MARK: Unlock with Face ID
                    Button(action: {
                        appLockViewModel.appLockValidation()
                    },
                           label: {
                        VStack {
                            Image("unlock-w")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(1)
                            Text("Unlock")
                                .font(.custom("Avenir", size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }.padding(5)
                    })
                }.padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Image(background_theme)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [.clear, np_arsenic, np_arsenic], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height * 0.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            
            // Mask Tint
            Rectangle()
                .fill(np_arsenic).opacity(0.85)
                .frame(height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: Day / Night Theme
    func getTime()->String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    private var background_theme : String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<19:
            return "snow-mountain"
        default:
            return "mountain-pond"
        }
    }
}
