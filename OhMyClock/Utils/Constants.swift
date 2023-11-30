//
//  Constants.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("users")

enum Constants {
    static let openAiKEy = "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"
}
