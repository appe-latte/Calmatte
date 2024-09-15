//
//  ThoughtRecordModelController.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-09-15.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class ThoughtRecordModelController: ObservableObject {
    
    @Published var thoughtRecords: [ThoughtRecord] = []
    
    let db = Firestore.firestore()
    
    init() {
        loadFromFirestore()
    }
    
    func createThoughtRecord(negativeThought: String, emotion: String, evidenceFor: String, evidenceAgainst: String, alternativeThought: String, date: Date) {
        let newRecord = ThoughtRecord(date: date, negativeThought: negativeThought, emotion: emotion, evidenceFor: evidenceFor, evidenceAgainst: evidenceAgainst, alternativeThought: alternativeThought)
        thoughtRecords.append(newRecord)
        saveToFirestore()
    }
    
    func deleteThoughtRecord(withID uuid: UUID) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userID).collection("thoughtRecords").document(uuid.uuidString).delete { [weak self] err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                DispatchQueue.main.async {
                    self?.thoughtRecords.removeAll { $0.id == uuid }
                }
            }
        }
    }
    
    func saveToFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        for record in thoughtRecords {
            do {
                let recordData = try record.asDictionary()
                let recordID = record.id.uuidString
                db.collection("users").document(userID).collection("thoughtRecords").document(recordID).setData(recordData, merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            } catch let error {
                print("Error writing thought records to Firestore: \(error)")
            }
        }
    }
    
    func loadFromFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        thoughtRecords = []
        
        db.collection("users").document(userID).collection("thoughtRecords").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting thought records: \(err)")
            } else {
                self.thoughtRecords = querySnapshot?.documents.compactMap { document in
                    let data = document.data()
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let decoder = JSONDecoder()
                        let record = try decoder.decode(ThoughtRecord.self, from: jsonData)
                        return record
                    } catch let error {
                        print("Error decoding thought record: \(error)")
                        return nil
                    }
                } ?? []
            }
        }
    }
}
