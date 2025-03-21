//
//  ThoughtRecordView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-09-15.
//

import SwiftUI

struct ThoughtRecordView: View {
    @State private var negativeThought = ""
    @State private var emotion = ""
    @State private var evidenceFor = ""
    @State private var evidenceAgainst = ""
    @State private var alternativeThought = ""
    
    @ObservedObject var thoughtRecordModelController = ThoughtRecordModelController()
    
    var body: some View {
        VStack {
            Text("Record Your Thoughts")
                .scaledToFill()
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .kerning(5)
                .minimumScaleFactor(0.5)
                .textCase(.uppercase)
            
            ScrollView {
                Group {
                    TextField("Negative Thought", text: $negativeThought)
                        .font(.title2)
                        .fontWeight(.bold)
                        .kerning(5)
                        .minimumScaleFactor(0.5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    TextField("Emotion", text: $emotion)
                        .font(.title2)
                        .fontWeight(.bold)
                        .kerning(5)
                        .minimumScaleFactor(0.5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    TextField("Evidence For", text: $evidenceFor)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Evidence Against", text: $evidenceAgainst)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Alternative Thought", text: $alternativeThought)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()

                Button("Save Thought Record") {
                    addThoughtRecord()
                }
                .padding(.vertical, 5)
                .foregroundColor(np_jap_indigo)
                .frame(width: 150, height: 50)
                .background(np_white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
                
                // Display saved records
                List(thoughtRecordModelController.thoughtRecords) { record in
                    VStack(alignment: .leading) {
                        Text("Negative Thought: \(record.negativeThought)")
                        Text("Emotion: \(record.emotion)")
                        Text("Evidence For: \(record.evidenceFor)")
                        Text("Evidence Against: \(record.evidenceAgainst)")
                        Text("Alternative Thought: \(record.alternativeThought)")
                        Text("Date: \(record.date, style: .date)")
                    }
                    .padding()
                }
            }
        }
        .padding()
        .onAppear {
            thoughtRecordModelController.loadFromFirestore()
            // Load data when the view appears
        }
    }
    
    // Function to add a new thought record and save it to Firestore
    func addThoughtRecord() {
        guard !negativeThought.isEmpty, !emotion.isEmpty, !evidenceFor.isEmpty, !evidenceAgainst.isEmpty, !alternativeThought.isEmpty else {
            // Add validation for empty fields
            return
        }
        
        let currentDate = Date()
        thoughtRecordModelController.createThoughtRecord(
            negativeThought: negativeThought,
            emotion: emotion,
            evidenceFor: evidenceFor,
            evidenceAgainst: evidenceAgainst,
            alternativeThought: alternativeThought,
            date: currentDate
        )
        
        // Clear the fields after saving
        clearFields()
    }
    
    // Helper function to clear input fields
    func clearFields() {
        negativeThought = ""
        emotion = ""
        evidenceFor = ""
        evidenceAgainst = ""
        alternativeThought = ""
    }
}

struct ThoughtRecordView_Previews: PreviewProvider {
    static var previews: some View {
        ThoughtRecordView()
    }
}
