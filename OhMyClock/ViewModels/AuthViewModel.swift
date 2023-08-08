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
    @Published var isSignedIn: Bool = false
    
    @Published var isError: Bool = false
    @Published var errorMsg: String = ""
    
    @Published var showSaveUserInfoView: Bool = false
    
    // MARK: Alert Toast
    @State var showDeleteAlert = false
    @State private var showAlert = false
    @State private var errTitle = ""
    @State private var errMessage = ""
    
    init(){
        Auth.auth().addStateDidChangeListener { (auth, user) in // attach listener to auth state
            self.isSignedIn = user != nil
        }
        
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
            
            self.userSession = result?.user // shows Content View after successful login
        }
    }
    
    // MARK: User Registration function
    func userRegistration(email: String, userPwd: String, firstName: String) {
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
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            self.userSession = nil
        } catch let signOutError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: Delete User functiona
    func deleteUser() {
        let userId = Auth.auth().currentUser!.uid
        Firestore.firestore().collection("users").document(userId).delete() { err in
            if let err = err  {
                print("Error: \(err)")
            } else {
                Auth.auth().currentUser!.delete { error in
                    if let error = error {
                        self.errTitle = "Error!"
                        self.errMessage = "Error deleting the user: \(error)"
                        self.showAlert = true
                    } else {
                        self.errTitle = "Account Deleted"
                        self.errMessage = "Your user account has successfully been deleted"
                        self.showAlert = true
                        self.signOut()
                    }
                }
            }
        }
        
        self.userSession = nil
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


