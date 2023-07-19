//
//  SignUpView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // MARK: Form Validation
    private var isFormValid: Bool {
        return !email.isEmpty && !password.isEmpty && !firstName.isEmpty
    }
    
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
                
                // MARK: Firstname field
                TextField("First Name", text: $firstName)
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
                
                // MARK: Email field
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
                
                // MARK: Pwd field
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
                
                // MARK: "Error Message" - duplicate account creation
                if authViewModel.isError {
                    Text(authViewModel.errorMsg)
                        .font(.footnote)
                        .kerning(3)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_white)
                        .padding()
                        .background(np_red).opacity(0.2)
                }
                
                // MARK: "Sign Up" button
                Button(action: {
                    authViewModel.userRegistration(email: email, userPwd: password, firstName: firstName)
                }) {
                    Text("Sign Up")
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
                .disabled(!isFormValid) // disable button if form is not valid
            }
            .padding()
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthViewModel())
    }
}


