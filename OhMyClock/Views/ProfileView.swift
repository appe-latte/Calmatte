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
    
    @State private var firstName = ""
    
    // MARK: Alert
    @State var showDeleteAlert = false
    @State private var showAlert = false
    @State private var errTitle = ""
    @State private var errMessage = ""
    
    // Load the current user's first name
    private func loadUserFirstName() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data(), let name = data["firstName"] as? String {
                firstName = name
            } else if let error = error {
                print("Error fetching user: \(error)")
            }
        }
    }
    
    // Save the updated first name
    private func saveFirstName() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userId).updateData([
            "firstName": firstName
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
            
            VStack {
                // MARK: Edit Name
                VStack {
                    HStack {
                        Text("First Name: ")
                            .font(.footnote)
                            .kerning(3)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Spacer()
                        
                        Button(action: {
                            //                            self.showDobUpdateSheetView.toggle()
                        }, label: {
                            Text("EDIT")
                                .font(.footnote)
                                .kerning(3)
                                .textCase(.uppercase)
                                .foregroundColor(np_green)
                        })
                    }
                    TextField("\(firstName)", text: $firstName)
                }
                
                Divider()
                    .background(np_gray)
                
                
                // MARK: Logout Button
                Button(action: {
                    authViewModel.signOut()
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
                        
                        Image(systemName: "chevron.right")
                    }
                })
                .padding(.horizontal, 20)
                
                Divider()
                    .background(np_gray)
                
                // MARK: "Delete" User Account
                VStack {
                    HStack {
                        Button(action: {
                            self.showDeleteAlert = true
                        }, label: {
                            HStack {
                                Image("trash")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(1)
                                Text("Delete My Account")
                                    .font(.custom("Avenir", size: 17))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 46 / 255, green: 153 / 255, blue: 168 / 255))
                                    .padding(.leading, 15)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .font(Font.title.weight(.semibold))
                                    .foregroundColor(Color(.gray)).opacity(0.5)
                                    .frame(width: 13, height: 13)
                            }
                        }).alert(isPresented:$showDeleteAlert) {
                            Alert(
                                title: Text("Are you sure you want to delete your account?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteUser()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    Text("This action permanently deletes your account and removes all of your information from our servers.").lineLimit(nil)
                        .foregroundColor(Color(red: 83 / 255, green: 82 / 255, blue: 116 / 255))
                        .font(.custom("Avenir", size: 11).bold())
                }
            }
        }
    }
    
    // MARK: Delete User functiona
    private func deleteUser() {
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
                        authViewModel.signOut()
                    }
                }
            }
        }
    }
}

struct ProfileView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
