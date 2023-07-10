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
            
            Image(background_theme)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [.clear, np_arsenic, np_arsenic], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height * 0.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            
            // Mask Tint
            Rectangle()
                .fill(np_arsenic).opacity(0.85)
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
    
    private var background_theme : String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<19:
            return "snow-mountain"
        default:
            return "mountain-pond"
        }
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Today")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .kerning(5)
                        .minimumScaleFactor(0.5)
                        .textCase(.uppercase)
                    
                    Text(Date().formatted(.dateTime.month().day().year()))
                        .font(.title3)
                        .fontWeight(.bold)
                        .kerning(5)
                        .textCase(.uppercase)
                    
                    // MARK: Description
                    Text("\(milestoneDescription)")
                        .font(.system(size: 10))
                        .kerning(3)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_black)
                }
                .hAlign(.leading)
                
                // MARK: "Add + Task" Button
                Button {
                    addNewTask.toggle()
                } label: {
                    HStack(spacing: 10){
                        Image(systemName: "plus")
                        Text("Add")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(5)
                            .textCase(.uppercase)
                    }
                    .padding(.vertical, 5)
                    .foregroundColor(np_white)
                    .frame(width: 100, height: 35)
                    .background(np_arsenic)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(np_white, style: StrokeStyle(lineWidth: 1))
                            .padding(2)
                    )
                }
            }
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                np_white
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
                .frame(width: screenWidth - 20, height: 25, alignment: .topLeading)
                .padding(.bottom, 10)
            
            // MARK: Date + Time
            HStack {
                Text(task.dateAdded.toString("hh:mm a"))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .kerning(3)
                    .textCase(.uppercase)
                
                Spacer()
                
                Text(task.dateAdded, formatter: dateFormatter)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .kerning(3)
                    .textCase(.uppercase)
            }
            .padding(.top, 15)
            .padding(.horizontal, 10)
            
            // MARK: Task Information
            Text(task.taskName)
                .font(.headline)
                .fontWeight(.semibold)
                .kerning(3)
                .textCase(.uppercase)
                .padding(.horizontal, 10)
            
            Text(task.taskDescription)
                .font(.footnote)
                .fontWeight(.semibold)
                .kerning(2)
                .textCase(.uppercase)
                .padding(.horizontal, 10)
            
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
        .frame(width: screenWidth - 30, height: screenHeight * 0.15)
        .foregroundColor(np_arsenic)
        .padding(5)
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



