//
//  TaskManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-12.
//

import SwiftUI
import CoreData

struct TaskManagerView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var currentDay: Date = .init()
    @State private var addNewTask: Bool = false
    @State private var selectedTaskIndex: Int?
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var milestoneDescription = "Develop a positive daily routine and organize your day with simple, achievable milestones."
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(taskManager.tasks.sorted(by: { $0.dateAdded < $1.dateAdded })) { task in
                    CardView(taskManager: taskManager, task: task)
                        .background(np_white)
                        .cornerRadius(15)
                }
            }
            .padding(.vertical)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HeaderView()
        }
        .sheet(isPresented: $addNewTask) {
            AddTaskView(taskManager: taskManager)
        }
        .background(background())
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_arsenic)
                .frame(height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: Day / Night Theme
    func getTime()->String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Daily Tasks")
                            .font(.title)
                            .fontWeight(.bold)
                            .kerning(5)
                            .minimumScaleFactor(0.5)
                            .textCase(.uppercase)
                            .foregroundColor(np_white)
                        
                        Spacer()
                        
                        // MARK: "Add + Task" Button
                        Button {
                            addNewTask.toggle()
                        } label: {
                            HStack(spacing: 10){
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                
                                Text("Add")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .kerning(2)
                                    .textCase(.uppercase)
                            }
                            .padding(.vertical, 5)
                            .foregroundColor(np_jap_indigo)
                            .frame(width: 100, height: 35)
                            .background(np_white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }
                    }
                    
                    Text(Date().formatted(.dateTime.month().day().year()))
                        .font(.title3)
                        .fontWeight(.bold)
                        .kerning(5)
                        .textCase(.uppercase)
                        .foregroundColor(np_white)
                    
                    // MARK: Description
                    Text("\(milestoneDescription)")
                        .font(.system(size: 10))
                        .kerning(3)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_white)
                }
                .hAlign(.leading)
            }
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                np_jap_indigo
            }
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
        }
    }
}

struct CardView: View {
    @ObservedObject var taskManager: TaskManager
    let task: TaskItem
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Rectangle()
                .fill(task.taskCategory.color)
                .frame(width: screenWidth - 20, height: 30, alignment: .topLeading)
                .padding(.bottom, 10)
            
            // MARK: Date + Time
            HStack {
                Text(task.dateAdded, formatter: dateFormatter)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .kerning(3)
                    .textCase(.uppercase)
                
                Spacer()
                
                Text(task.dateAdded.toString("hh:mm a"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .kerning(3)
                    .textCase(.uppercase)
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            
            // MARK: Task Information
            Text(task.taskName)
                .font(.headline)
                .fontWeight(.semibold)
                .kerning(3)
                .textCase(.uppercase)
                .padding(.horizontal, 15)
            
            Text(task.taskDescription)
                .font(.footnote)
                .fontWeight(.semibold)
                .kerning(2)
                .textCase(.uppercase)
                .padding(.horizontal, 15)
            
            // MARK: "Delete" button
            HStack {
                Spacer()
                
                Button(action: {
                    taskManager.deleteTask(task)
                }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.headline)
                        .foregroundColor(np_red).opacity(0.65)
                }
            }
            .padding(.bottom, 10)
        }
        .frame(maxWidth: screenWidth - 30, maxHeight: screenHeight * 0.25)
        .foregroundColor(np_arsenic)
    }
}

// MARK: View Extensions
extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
}

// MARK: Date Extension
extension Date {
    func toString(_ format: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}



