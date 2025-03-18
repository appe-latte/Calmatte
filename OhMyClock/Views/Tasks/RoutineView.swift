//
//  RoutineView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2025-03-05.
//

import SwiftUI
import CoreData
import AlertToast

struct RoutineView: View {
    @ObservedObject var taskManager: TaskManager
    @State var task: TaskItem

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, YYYY"
        return formatter
    }()

    var body: some View {
        HStack(alignment: .center) {
            // MARK: Checkbox Button
            Button(action: {
                task.isCompleted.toggle()
                taskManager.updateTask(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? np_green : np_gray)
            }
            .buttonStyle(PlainButtonStyle()) // Remove button styling

            VStack(alignment: .leading, spacing: 2) {
                // MARK: Task Information
                Text(task.taskName)
                    .font(.headline)
                    .fontWeight(.medium)
                    .kerning(2)
                    .foregroundColor(np_arsenic)
                    .strikethrough(task.isCompleted, color: np_arsenic.opacity(0.5))
                
                // MARK: Time - Subtler time display
                Text(task.dateAdded.toString("hh:mm a"))
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(np_gray)
            }
            .padding(.leading, 10)

            Spacer()

            // MARK: "Delete" button
            Button(action: {
                taskManager.deleteTask(task)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(np_red).opacity(0.5)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(np_white)
    }
}
