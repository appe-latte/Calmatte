//
//  TaskManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-12.
//

import SwiftUI

struct TaskManagerView: View {
    @State private var currentDay: Date = .init()
    @State private var tasks: [TaskItem] = []
    @State private var addNewTask: Bool = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TimelineView()
                .padding(15)
                .foregroundColor(np_white)
                .background(np_black)
        }
        .safeAreaInset(edge: .top,spacing: 0) {
            HeaderView()
                
        }
        .fullScreenCover(isPresented: $addNewTask) {
            AddTaskView { task in
                tasks.append(task)
            }
        }
    }
    
    /// - Timeline View
    @ViewBuilder
    func TimelineView() -> some View {
        ScrollViewReader { proxy in
            let hours = Calendar.current.hours
            let midHour = hours[hours.count / 2]
            VStack {
                ForEach(hours,id: \.self) { hour in
                    TimelineViewRow(hour)
                        .id(hour)
                }
            }
            .onAppear {
                proxy.scrollTo(midHour)
            }
        }
    }
    
    /// - Timeline View Row
    @ViewBuilder
    func TimelineViewRow(_ date: Date) -> some View {
        HStack(alignment: .top) {
            Text(date.toString("h a"))
                .font(.footnote)
                .fontWeight(.bold)
                .kerning(5)
                .textCase(.uppercase)
                .frame(width: screenWidth * 0.1, alignment: .leading)
            
            /// - Filtering Tasks
            let calendar = Calendar.current
            let filteredTasks = tasks.filter {
                if let hour = calendar.dateComponents([.hour], from: date).hour,
                   let taskHour = calendar.dateComponents([.hour], from: $0.dateAdded).hour,
                   hour == taskHour && calendar.isDate($0.dateAdded, inSameDayAs: currentDay){
                    return true
                }
                return false
            }
            
            if filteredTasks.isEmpty {
                Rectangle()
                    .stroke(np_white.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, lineCap: .butt))
                    .frame(height: 0.5)
                    .offset(y: 10)
            } else {
                /// - Task View
                VStack(spacing: 10){
                    ForEach(filteredTasks){ task in
                        TaskRow(task)
                    }
                }
            }
        }
        .hAlign(.leading)
        .padding(.vertical,15)
    }
    
    /// - Task Row
    @ViewBuilder
    func TaskRow(_ task: TaskItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.taskName.uppercased())
                .font(.footnote)
                .fontWeight(.bold)
                .kerning(5)
                .textCase(.uppercase)
                .foregroundColor(np_white)
                .lineLimit(1)
            
            if task.taskDescription != "" {
                Text(task.taskDescription)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .kerning(5)
                    .textCase(.uppercase)
                    .foregroundColor(task.taskCategory.color)
                    .lineLimit(6)
            }
        }
        .hAlign(.leading)
        .padding(12)
        .background {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(task.taskCategory.color)
                    .frame(width: 4)
                
                Rectangle()
                    .fill(task.taskCategory.color.opacity(0.25))
            }
        }
    }
    
    /// - Header View
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
                }
                .hAlign(.leading)
                
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
                    .background(np_black)
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
    
    /// - Week Row
    @ViewBuilder
    func WeekRow() -> some View {
        HStack(spacing: 0) {
            ForEach(Calendar.current.currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                VStack(spacing: 6) {
                    Text(weekDay.string.prefix(3))
                        .font(.footnote)
                        .fontWeight(.bold)
                        .kerning(5)
                        .textCase(.uppercase)
                    
                    Text(weekDay.date.toString("dd"))
                        .font(.footnote)
                        .fontWeight(.bold)
                        .kerning(5)
                        .textCase(.uppercase)
                }
                .overlay(alignment: .bottom, content: {
                    if weekDay.isToday {
                        Circle()
                            .frame(width: 6, height: 6)
                            .offset(y: 12)
                    }
                })
                .foregroundColor(status ? np_black : np_gray)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)){
                        currentDay = weekDay.date
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, -15)
    }
}

struct TaskManager_Previews : PreviewProvider {
    static var previews : some View {
        ContentView()
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

// MARK: Calander Extension
extension Calendar {
    /// - Return 24 Hours in a day
    var hours: [Date] {
        let startOfDay = self.startOfDay(for: Date())
        let currentHour = self.component(.hour, from: Date())
        var hours: [Date] = []
        
        for index in 0..<24 {
            if let date = self.date(bySettingHour: index, minute: 0, second: 0, of: startOfDay) {
                if index == currentHour {
                    hours.append(date) // Add the current hour with a special marker
                } else {
                    hours.append(date)
                }
            }
        }
        
        return hours
    }
    
    /// - Returns Current Week in Array Format
    var currentWeek: [WeekDay] {
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start else { return [] }
        var week: [ WeekDay ] = []
        for index in 0..<7 {
            if let day = self.date(byAdding: .day, value: index, to: firstWeekDay) {
                let weekDaySymbol : String = day.toString("EEEE")
                let isToday = self.isDateInToday(day)
                week.append(.init(string: weekDaySymbol, date: day,isToday: isToday))
            }
        }
        
        return week
    }
    
    /// - Used to Store Data of Each Week Day
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var string: String
        var date: Date
        var isToday: Bool = false
    }
}
