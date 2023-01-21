//
//  TasksView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI

struct TasksView: View {
    @State private var showAddTasksView = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                // MARK: "Heading"
                 HStack {
                    Text("Daily Milestones")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(np_white)
                        .minimumScaleFactor(0.75)
                     
                     Spacer()
                     
                     addTaskButton()
                         .padding()
                         .onTapGesture {
                             showAddTasksView.toggle()
                         }
                }
                 .frame(maxWidth: .infinity, alignment: .leading)
                 .padding(.horizontal, 10)
                
                // MARK: "Description"
                HStack {
                    Text("Make a short list of achievable milestones for the day.")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(np_white)
                        .minimumScaleFactor(0.75)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [np_black, .black]), startPoint: .bottomTrailing, endPoint: .topLeading))
        }
        .blurredSheet(.init(.ultraThinMaterial), show: $showAddTasksView) {
            //
        } content: {
            if #available(iOS 16.0, *) {
                AddTasksView()
            } else {
                // Fallback on earlier versions
                AddTasksView()
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}

// MARK: "Add New Task" button

struct addTaskButton : View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, alignment: .center)
                .overlay(
                    Text("+")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(np_white)
                )
        }
        .frame(height: 40, alignment: .center)
        .overlay(
            Circle()
                .stroke(np_white, style: StrokeStyle(lineWidth: 1))
                                .padding(2)
        )
    }
}
