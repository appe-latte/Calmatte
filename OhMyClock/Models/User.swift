//
//  User.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import Foundation
import FirebaseCore
import FirebaseAuth

struct User: Identifiable {
    let id : String
    let firstName : String
    let email : String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == self.id }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["uid"] as? String ?? ""
        self.firstName = dictionary["first_name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
