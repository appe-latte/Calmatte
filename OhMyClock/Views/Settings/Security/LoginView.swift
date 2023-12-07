//
//  LoginView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import LocalAuthentication

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center, spacing: 15) {
                    // MARK: Logo
                    Image("logo-text")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenWidth / 4, height: screenHeight / 4)
                        .foregroundColor(np_white)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    VStack {
                        // MARK: Email Field
                        TextField("Email", text: $email)
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
                        
                        // MARK: Pwd Field
                        SecureField("Password", text: $password)
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
                        
                        // MARK: "Forgot Password" button
                        HStack {
                            Spacer()
                            
                            NavigationLink(destination: PasswordResetView()) {
                                Text("Forgot Password")
                                    .font(.system(size:10))
                                    .fontWeight(.semibold)
                                    .kerning(3)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                            }
                        }
                        .padding(1)
                        .padding(.bottom, 10)
                    }
                    
                    // MARK: Error Message
                    if authViewModel.isError {
                        Text(authViewModel.errorMsg)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .kerning(2)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(np_white)
                            .padding()
                            .background(np_red).opacity(0.2)
                    }
                    
                    // MARK: "Login" Button
                    Button(action: {
                        authViewModel.userLogin(withEmail: email, password: password)
                    }) {
                        Text("Log In")
                            .font(.footnote)
                            .bold()
                            .kerning(3)
                            .textCase(.uppercase)
                    }
                    .padding(.vertical, 5)
                    .foregroundColor(np_jap_indigo)
                    .frame(width: 150, height: 50)
                    .background(np_white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 50)
                    
                    NavigationLink(destination: SignUpView()) {
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size:10))
                                .fontWeight(.semibold)
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_gray)
                            
                            Text("Sign Up")
                                .font(.system(size:10))
                                .fontWeight(.semibold)
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding()
            }
            .background(background())
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Image("img-bg")
                .resizable()
                .scaledToFill()
                .frame(height: size.height, alignment: .bottom)
            
            Rectangle()
                .fill(np_arsenic)
                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}

