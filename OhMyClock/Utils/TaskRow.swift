//
//  TaskRow.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-17.
//

import SwiftUI

struct TaskRow : View {
    var task : String
    var completed : Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: completed ? "checkmark.circle" : "checkmark")
            Text(task)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: "Morning Meditation", completed: true)
    }
}
