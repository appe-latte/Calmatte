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
            Image(systemName: completed ? "square.inset.filled" : "square")
            Text(task)
                .font(.footnote)
                .kerning(3)
                .textCase(.uppercase)
                .minimumScaleFactor(0.75)
        }
        .foregroundColor(np_arsenic)
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: "Morning Meditation", completed: true)
    }
}
