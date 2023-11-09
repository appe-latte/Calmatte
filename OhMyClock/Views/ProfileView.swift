//
//  ProfileView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-08-07.
//

import SwiftUI
import AlertToast
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @Binding var showProfileSheet : Bool
    
    @State private var firstName = ""
    
    // MARK: Alert Toast
    @State var showDeleteAlert = false
    @State private var showAlert = false
    @State private var errTitle = ""
    @State private var errMessage = ""
    
    // MARK: Load the current user's first name
    private func loadUserFirstName() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data(), let name = data["first_name"] as? String {
                firstName = name
            } else if let error = error {
                print("Error fetching user: \(error)")
            }
        }
    }
    
    // MARK: Save the updated first name
    private func saveFirstName() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).updateData([
            "first_name": firstName
        ]) { error in
            if let error = error {
                errTitle = "Error"
                errMessage = "An error occurred: \(error.localizedDescription)"
                showAlert = true
            } else {
                errTitle = "Success"
                errMessage = "Successfully updated your name."
                showAlert = true
            }
        }
    }
    
    var body: some View {
        ZStack {
            np_jap_indigo
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15) {
                
                VStack {
                    HStack {
                        Text("Your Profile")
                            .font(.title)
                            .fontWeight(.bold)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: Edit First name
                    HStack {
                        Text("Edit Name: ")
                            .font(.footnote)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        TextField("\(firstName)", text: $firstName)
                            .font(.footnote)
                            .kerning(3)
                            .foregroundColor(np_white)
                        
                        Spacer()
                        
                        Button(action: {
                            saveFirstName()
                        }, label: {
                            Text("Save")
                                .font(.system(size: 10))
                                .bold()
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_turq)
                        })
                    }
                }
                .onAppear(perform: loadUserFirstName)
            
                Divider()
                    .background(np_gray)
                
                // MARK: Logout Button
                Button(action: {
                    authViewModel.signOut()
                    showProfileSheet = false
                }, label: {
                    HStack(spacing: 10) {
                        Image("logout")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("Logout")
                            .font(.footnote)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                    }
                })
                
                Divider()
                    .background(np_gray)
                
                // MARK: "Delete" User Account
                VStack {
                    HStack {
                        Button(action: {
                            self.showDeleteAlert = true
                        }, label: {
                            HStack(spacing: 10) {
                                Image(systemName: "trash.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(np_red)
                                
                                Text("Delete My Account")
                                    .font(.footnote)
                                    .kerning(3)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                
                                Spacer()
                            }
                        })
                        .alert(isPresented:$showDeleteAlert) {
                            Alert(
                                title: Text("Are you sure you want to delete your account?"),
                                primaryButton: .destructive(Text("Delete")) {
//                                    deleteUser()
                                    authViewModel.deleteUser()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    
                    Text("This action permanently deletes your account and removes all of your information from our servers.").lineLimit(nil)
                        .font(.system(size: 8))
                        .kerning(1)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                        .padding(3)
                }
                
                Divider()
                    .background(np_gray)
            }
            .padding(.horizontal, 20)
        }
    }
}
