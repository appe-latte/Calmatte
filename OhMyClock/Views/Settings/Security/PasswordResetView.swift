//
//  PasswordResetView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-21.
//

import SwiftUI

struct PasswordResetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var passwordReset = PasswordResetViewModelImpl(
        service: PasswordResetServiceImpl()
    )
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            background()
            
            VStack(alignment: .center, spacing: 15) {
                // MARK: Logo
                Image("logo-text")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth / 4, height: screenHeight / 4)
                    .foregroundColor(np_white)
                    .padding(.top, 50)
                
                Spacer()
                
                HStack {
                    Text("Reset Password")
                        .font(.title2)
                        .fontWeight(.bold)
                        .kerning(5)
                        .minimumScaleFactor(0.5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    Spacer()
                }
                
                // MARK: Email Field
                TextField("Email", text: $passwordReset.email)
                    .font(.footnote)
                    .kerning(3)
                    .textCase(.uppercase)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(np_white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(np_white, lineWidth: 0.5)
                    )
                    .keyboardType(.emailAddress)
                
                // MARK: "Send Request" Button
                Button(action: {
                    passwordReset.sendPasswordReset()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Reset Password")
                        .font(.footnote)
                        .bold()
                        .kerning(3)
                        .textCase(.uppercase)
                })
                .padding(.vertical, 5)
                .foregroundColor(np_jap_indigo)
                .frame(width: 200, height: 50)
                .background(np_white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
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
                .fill(np_arsenic)
//                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

struct PasswordResetView_Previews : PreviewProvider {
    static var previews : some View {
        PasswordResetView()
    }
}
