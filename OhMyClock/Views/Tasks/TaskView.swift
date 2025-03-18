//
//  TaskManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-12.
//

import SwiftUI
import CoreData
import AlertToast

struct TaskView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var currentDay: Date = .init()
    @State private var addNewTask: Bool = false
    @State private var selectedTaskIndex: Int?
    
    @State private var showCompletionAnimation = false
    @State private var showAlert = false
    @State private var tasksComplete = false
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @State private var milestoneDescription = "Conquer the day by setting and completing daily tasks."
    
    var body: some View {
        ZStack {
            background()
            
            VStack {
                HeaderView()
                
                // MARK: "Task" List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(taskManager.tasks.sorted(by: { $0.dateAdded < $1.dateAdded })) { task in
                            CardView(taskManager: taskManager, task: task)
                                .background(np_white)
                                .cornerRadius(15)
                        }
                        
                        // MARK: Completion Check + Animation
                        if taskManager.totalTasksCount > 0 && taskManager.completedTasksCount == taskManager.totalTasksCount {
                            LottieAnimView(animationFileName: "success", loopMode: .playOnce)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width, height: height)
                                .onAppear {
                                    showAlert = true
                                    HapticManager.instance.hapticSuccess()
                                }
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                    .padding(.vertical)
                }
                
                // MARK: Progress Bar
                Capsule()
                    .fill(np_arsenic).opacity(0.1)
                    .frame(width: width - 20, height: 50)
                    .clipShape(Capsule())
                    .overlay {
                        
                        progressBar()
                    }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Great Work!"),
                message: Text("You've completed all your tasks for today! Take a moment to enjoy this accomplishment and the positive impact on your well-being. Ready to clear the slate for tomorrow's new beginnings?"),
                primaryButton: .default(Text("Clear"), action: {
                    taskManager.clearCompletedTasks()
                }),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $addNewTask) {
            AddTaskView(taskManager: taskManager)
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_jap_indigo)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: Day / Night Theme
    func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                      
                        Spacer()
                        
                        // MARK: "Add + Task" Button
                        Button(action: {
                            addNewTask.toggle()
                        }, label: {
                            Image("add")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .foregroundColor(np_white)
                                .padding(5)
                        })
                        .frame(width: 40, height: 40)
                    }
                    
                    // MARK: Week
                    TaskWeekView()
                        .padding(.horizontal, 2)
                        .padding(.vertical, 5)
                }
                .hAlign(.leading)
            }
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                np_jap_indigo
            }
            .ignoresSafeArea()
        }
    }
    
    // MARK: Progress Bar
    @ViewBuilder
    func progressBar() -> some View {
        VStack {
            HStack {
                Text("Completed:")
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
                    .kerning(1)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
                
                Spacer()
            }
            
            HStack {
                ProgressView(value: Double(taskManager.completedTasksCount),
                             total: Double(taskManager.totalTasksCount))
                .progressViewStyle(LinearProgressViewStyle())
                .frame(width: width * 0.8)
                .padding(5)
                
                Text("\(taskManager.completedTasksCount)/\(taskManager.totalTasksCount)")
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
                    .kerning(1)
                    .textCase(.uppercase)
                    .foregroundColor(np_white)
            }
        }
    }
}

struct CardView: View {
    @ObservedObject var taskManager: TaskManager
    @State var task: TaskItem
    
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
                .kerning(1)
            //                .textCase(.uppercase)
                .padding(.horizontal, 15)
            
            // MARK: "Delete" button
            HStack {
                Button(action: {
                    taskManager.deleteTask(task)
                }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.headline)
                        .foregroundColor(np_red).opacity(0.65)
                }
                
                Spacer()
                
                Button(action: {
                    task.isCompleted.toggle()
                    taskManager.updateTask(task)
                }) {
                    HStack {
                        Text(task.isCompleted ? "Completed" : "Complete?")
                            .font(.system(size: 10))
                            .fontWeight(.medium    )
                            .kerning(1)
                            .textCase(.uppercase)
                            .foregroundColor(np_jap_indigo)
                        
                        Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                            .font(.system(size: 15))
                            .foregroundColor(task.isCompleted ? np_red : np_jap_indigo)
                    }
                }
            }
            .padding(.horizontal, 10)
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

extension TaskManager {
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var totalTasksCount: Int {
        tasks.count
    }
}

struct TaskWeekView: View {
    private var calendar = Calendar.current
    private let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    private var currentWeek: [Date] {
        currentWeekDates()
    }
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<7, id: \.self) { index in
                VStack {
                    Text(daysOfWeek[index])
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(np_white)
                    
                    Text(dayOfMonth(for: currentWeek[index]))
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(isToday(date: currentWeek[index]) ? np_jap_indigo : np_gray)
                        .frame(width: 40, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).fill(isToday(date: currentWeek[index]) ? np_white : np_arsenic))
                        .overlay(
                            isToday(date: currentWeek[index]) ? nil : RoundedRectangle(cornerRadius: 10).stroke(np_arsenic, lineWidth: 1)
                        )
                }
            }
        }
    }
    
    private func isToday(date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    private func dayOfMonth(for date: Date) -> String {
        let day = calendar.component(.day, from: date)
        return String(format: "%02d", day)
    }
    
    private func currentWeekDates() -> [Date] {
        let today = Date()
        let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: today)!
        
        var weekArray: [Date] = []
        for i in 0..<7 {
            if let weekDay = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                weekArray.append(weekDay)
            }
        }
        return weekArray
    }
}
