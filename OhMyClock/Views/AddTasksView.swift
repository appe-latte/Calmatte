//
//  AddTasksView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-21.
//

import SwiftUI

struct AddTasksView: View {
    @EnvironmentObject var realmManager : OmcRealmManager
    @State var title : String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Add Daily Milestone")
                .font(.title)
                .fontWeight(.bold)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: "textfield"
            
            TextField("Enter milestone here...", text: $title)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(np_black)
            
            // MARK: "Save" button
            
            HStack {
                Spacer()
                
                Button(action: {
                    if title != "" {
                        realmManager.addMilestone(title: title)
                    }
                    dismiss()
                }, label: {
                    Text("Save")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .kerning(7)
                        .textCase(.uppercase)
                })
                .padding(.vertical, 5)
                .foregroundColor(np_white)
                .frame(width: 100, height: 35)
                .background(np_black)
                .clipShape(Capsule())
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(np_white, style: StrokeStyle(lineWidth: 1))
                        .padding(2)
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal)
        .background(np_white)
    }
}

struct AddTasksView_Previews: PreviewProvider {
    static var previews: some View {
        AddTasksView()
            .environmentObject(OmcRealmManager())
    }
}
