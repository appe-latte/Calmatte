//
//  AuthViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? // tracks if user is logged in
    @Published var isAuthenticating = false // blocks buttons and textfields during authentication
    @Published var error: Error? // Displays error message
    @Published var user: User? // Keeps track of the user
    
    @Published var isError: Bool = false
    @Published var errorMsg: String = ""
    
    @Published var showSaveUserInfoView: Bool = false
    
    init(){
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    // MARK: User Login function
    
    func userLogin(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.isError.toggle()
                self.errorMsg = error?.localizedDescription ?? ""
                return
            }
            
            // MARK: Shows Content View after successful login
            self.userSession = result?.user
        }
    }
    
    // MARK: User Registration function
    func userRegistration(email: String, userPwd: String, firstName: String) {
        
        // MARK: Upload to Firebase
        Auth.auth().createUser(withEmail: email, password: userPwd) { result, error in
            if error != nil {
                self.isError.toggle()
                self.errorMsg = error?.localizedDescription ?? ""
                return
            }
            guard let user = result?.user else { return }
            
            let data = ["email": email,
                        "first_name": firstName,
                        "uid": user.uid
            ]
            
            Firestore.firestore().collection("users").document(user.uid).setData(data) { _ in
                self.userSession = result?.user
                self.fetchUser()
            }
        }
        
    }
    
    // MARK:  Sign Out function
    func signOut() {
        userSession = nil
        try? Auth.auth().signOut()
    }
    
    // MARK: Fetch User function
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).addSnapshotListener(includeMetadataChanges: false) { documentSnapshot, error in
            
            if let snapshotData = documentSnapshot?.data() {
                let user = User(dictionary: snapshotData)
                self.user = user
                self.showSaveUserInfoView = false
            } else {
                self.showSaveUserInfoView = true
            }
        }
    }
}


