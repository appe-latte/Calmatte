//
//  AddTaskView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-12.
//

import SwiftUI
import CoreData
import UserNotifications

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var taskManager: TaskManager
    
    @State private var taskName: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskCategory: Category = .tan
    @State private var isCompleted: Bool = false
    
    // MARK: Animations
    @State private var animateColor: Color = Category.tan.color
    @State private var animate: Bool = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 20) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(np_arsenic)
                            .contentShape(Rectangle())
                    }
                    
                    Text("Create New Task")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .kerning(3)
                        .textCase(.uppercase)
                        .foregroundColor(np_arsenic)
                }
                .padding(.bottom, 15)
                
                TitleView("Task Date")
                
                // MARK: Date Picker
                DatePicker("", selection: $taskDate, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .accentColor(np_arsenic)
                    .kerning(2)
                    .textCase(.uppercase)
                    .frame(width: screenWidth - 50, height: screenHeight * 0.3, alignment: .leading)
                    .padding(10)
                    .padding(.top, 15)
                
                TitleView("Task Title")
                    .padding(.top, 20)
                
                TextField("Enter task title", text: $taskName)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .kerning(2)
                    .textCase(.uppercase)
                    .frame(width: screenWidth - 20)
                    .tint(np_arsenic)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(np_white.opacity(0.7))
                    .frame(height: 1)
                
                TitleView("Reminder Time")
                    .padding(.top, 10)
                
                // MARK: Date + Time Pickers
                HStack(alignment: .bottom, spacing: 5) {
                    HStack(spacing: 3){
                        Text(taskDate.toString("hh:mm a"))
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(2)
                            .textCase(.uppercase)
                            .frame(width: screenWidth * 0.25, alignment: .leading)
                            .overlay {
                                DatePicker("", selection: $taskDate,displayedComponents: [.hourAndMinute])
                                    .blendMode(.destinationOver)
                            }
                        
                        Image(systemName: "clock")
                            .font(.title3)
                            .foregroundColor(np_white)
                        
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(np_white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                }
            }
            .hAlign(.leading)
            .padding(15)
            .background {
                ZStack {
                    taskCategory.color
                    
                    GeometryReader {
                        let size = $0.size
                        Rectangle()
                            .fill(animateColor)
                            .mask {
                                Rectangle()
                            }
                            .frame(width: animate ? size.width * 2 : 0, height: animate ? size.height * 2 : 0)
                            .offset(animate ? CGSize(width: -size.width / 2, height: -size.height / 2) : size)
                    }
                    .clipped()
                }
                .ignoresSafeArea()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                TitleView("Assign Colour", np_arsenic)
                    .padding(.top, 10)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: 10), count: 4), spacing: 10) {
                    ForEach(Category.allCases,id: \.rawValue){ category in
                        Circle()
                            .fill(category.color)
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                guard !animate else { return }
                                animateColor = category.color
                                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1, blendDuration: 1)){
                                    animate = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
                                    animate = false
                                    taskCategory = category
                                }
                            }
                            .padding(.leading, 10)
                    }
                }
                .padding(.top,5)
                
                Button {
                    // MARK: Creating Task & pass to callback
                    let task = TaskItem(dateAdded: taskDate, taskName: taskName, taskCategory: taskCategory, isCompleted: isCompleted)
                    taskManager.addTask(task) // Add the task to the task manager
                    dismiss()
                } label: {
                    Text("Create Task")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .kerning(5)
                        .textCase(.uppercase)
                        .frame(width: screenWidth * 0.5)
                        .foregroundColor(np_white)
                        .padding(.vertical,15)
                        .hAlign(.center)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(np_arsenic)
                        }
                }
                .vAlign(.bottom)
                .disabled(taskName == "" || animate)
                .opacity(taskName == "" ? 0.6 : 1)
            }
            .padding(15)
        }
        .vAlign(.top)
        .background(np_white)
    }
    
    @ViewBuilder
    func TitleView(_ value: String,_ color: Color = np_arsenic.opacity(0.7)) -> some View {
        Text(value)
            .font(.caption)
            .fontWeight(.bold)
            .kerning(5)
            .textCase(.uppercase)
            .frame(width: screenWidth * 0.5, alignment: .leading)
            .foregroundColor(color)
    }
}

class TaskManager: ObservableObject {
    @Published private(set) var tasks: [TaskItem] = []
    
    init() {
        requestNotificationPermission()
        loadTasks()
    }
    
    func addTask(_ task: TaskItem) {
        tasks.append(task)
        saveTasks()
        scheduleNotification(for: task)
    }
    
    func updateTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            let oldTask = tasks[index]
            tasks[index] = task
            saveTasks()
            updateNotification(for: oldTask, with: task)
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            saveTasks()
            removeNotification(for: task)
        }
    }
    
    func deleteTasks(at indices: IndexSet) {
        let tasksToDelete = indices.compactMap { tasks[$0] }
        tasks.remove(atOffsets: indices)
        saveTasks()
        tasksToDelete.forEach(removeNotification)
    }
    
    func markTaskAsCompleted(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = true
            saveTasks()
            removeNotification(for: task)
        }
    }
    
    func clearCompletedTasks() {
        tasks.removeAll { $0.isCompleted }
        saveTasks()
    }
    
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: "savedTasks")
        } catch {
            print("Error encoding tasks: \(error)")
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "savedTasks") {
            do {
                tasks = try JSONDecoder().decode([TaskItem].self, from: data)
            } catch {
                print("Error decoding tasks: \(error)")
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleNotification(for task: TaskItem) {
        let content = UNMutableNotificationContent()
        content.title = "Calmatte App: Task Reminder"
        content.body = task.taskName
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.dateAdded)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func removeNotification(for task: TaskItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
    
    private func updateNotification(for oldTask: TaskItem, with newTask: TaskItem) {
        removeNotification(for: oldTask)
        scheduleNotification(for: newTask)
    }
}


// MARK: Time Picker intervals
extension Date {
    func roundedToNextFiveMinutes() -> Date {
        let calendar = Calendar.current
        let nextDiff = 5 - calendar.component(.minute, from: self) % 5
        let nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: self) ?? self
        return calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextDate)) ?? self
    }
}

