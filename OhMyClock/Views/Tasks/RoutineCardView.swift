//
//  RoutineCardView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2025-03-05.
//

import SwiftUI
import CoreData
import AlertToast

struct RoutineCardView: View {
    @ObservedObject var routineManager: RoutineManager
    @State var routine: Routine
    
    @State private var showingActionSheet = false
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(routine.name)
                .font(.title3)
                .fontWeight(.heavy)
                .textCase(.uppercase)
                .foregroundColor(np_jap_indigo)
            
            HStack {
                Text("Time: \(dateFormatter.string(from: routine.startTime))")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(np_arsenic)
                    .textCase(.uppercase)
                    .frame(height: 20)
                
                Spacer()
                
                Text(days(abbreviation: routine.daysOfWeek))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .frame(width: 100, height: 20)
                    .foregroundColor(np_white)
                    .background(np_arsenic)
                    .clipShape(Capsule())
            }
        }
        .padding(15)
        .frame(width: width - 20, height: 80, alignment: .leading)
        .background(np_white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onTapGesture {
            showingActionSheet = true
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Routine Actions"),
                message: Text("What would you like to do with this routine?"),
                buttons: [
                    .default(Text("Edit")) {
                        routineManager.startEditing(routine: routine)
                    },
                    .destructive(Text("Delete")) {
                        routineManager.deleteRoutine(routine: routine)
                    },
                    .cancel()
                ]
            )
        }
    }
    
    func days(abbreviation daysOfWeek: [Int]) -> String {
        let daySymbols = Calendar.current.shortWeekdaySymbols
        var dayAbbreviations = [String]()
        for dayIndex in daysOfWeek {
            dayAbbreviations.append(daySymbols[dayIndex].prefix(1).uppercased())
        }
        return dayAbbreviations.joined(separator: ", ")
    }
}

struct AddRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var routineManager: RoutineManager
    
    @State private var routineName: String = ""
    @State private var selectedDays: [Int] = []
    @State private var startTime: Date = Date()
    @State private var reminderEnabled: Bool = false
    @State private var reminderType: ReminderType = .time
    
    @State private var isEditing: Bool = false
    @State private var routineID: UUID? = nil
    
    let daysOfWeek = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // Initialization for Edit Mode
    init(routineManager: RoutineManager, routineToEdit: Routine? = nil) {
        _routineManager = ObservedObject(wrappedValue: routineManager)
        
        if let routineToEdit = routineToEdit {
            _routineName = State(initialValue: routineToEdit.name)
            _selectedDays = State(initialValue: routineToEdit.daysOfWeek)
            _startTime = State(initialValue: routineToEdit.startTime)
            _reminderEnabled = State(initialValue: routineToEdit.reminderEnabled)
            _reminderType = State(initialValue: routineToEdit.reminderType)
            _isEditing = State(initialValue: true)
            _routineID = State(initialValue: routineToEdit.id)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // MARK: Routine Name
            TextField("Enter Routine Title", text: $routineName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .kerning(2)
                .textCase(.uppercase)
                .foregroundColor(np_arsenic)
                .padding(.top, 20)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 20) {
                // MARK: Repeat Section
                SectionView(title: "Schedule") {
                    HStack(spacing: 8) {
                        ForEach(0..<daysOfWeek.count, id: \.self) { index in
                            DayButton(day: daysOfWeek[index], isSelected: selectedDays.contains(index)) {
                                if selectedDays.contains(index) {
                                    selectedDays.removeAll(where: { $0 == index })
                                } else {
                                    selectedDays.append(index)
                                }
                            }
                        }
                    }
                }
                
                // MARK: Routine Time
                SectionView(title: "Starts at") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            DatePicker("Time:", selection: $startTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .accentColor(np_arsenic)
                                .scaleEffect(0.8)
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        
                        Button(action: { reminderType = .time }) {
                            Text("Time")
                                .font(.caption)
                                .clipShape(Capsule())
                                .frame(width: 60)
                                .foregroundColor(reminderType == .time ? .white : np_arsenic)
                                .background(reminderType == .time ? np_arsenic : Color.clear)
                        }
                    }
                }
                
                // MARK: Reminder Section
                SectionView(title: "Reminder") {
                    HStack {
                        Text("Set Reminder")
                            .fontWeight(.semibold)
                            .foregroundColor(np_arsenic)
                            .textCase(.uppercase)
                        
                        Spacer()
                        
                        Toggle("", isOn: $reminderEnabled)
                            .labelsHidden()
                    }
                }
            }
            .padding(.horizontal, 25)
            
            // MARK: "Done" Button
            Button(action: {
                if isEditing, let routineID = routineID {
                    let updatedRoutine = Routine(id: routineID, name: routineName, daysOfWeek: selectedDays, startTime: startTime, reminderEnabled: reminderEnabled, reminderType: reminderType)
                    routineManager.updateRoutine(routine: updatedRoutine)
                } else {
                    let newRoutine = Routine(name: routineName, daysOfWeek: selectedDays, startTime: startTime, reminderEnabled: reminderEnabled, reminderType: reminderType)
                    routineManager.addRoutine(newRoutine)
                }
                dismiss()
            }) {
                Text("Save Routine")
                    .font(.headline)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(np_arsenic)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 20)
            
        }
        .vAlign(.top)
        .background(np_white)
    }
    
    // MARK: Section View
    @ViewBuilder
    func SectionView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .foregroundColor(np_arsenic.opacity(0.7))
                .padding(.bottom, 5)
            
            content()
            
            Divider()
                .background(np_gray.opacity(0.3))
        }
    }
    
    // MARK: Day Button View
    @ViewBuilder
    func DayButton(day: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(day)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : np_arsenic)
                .frame(width: 30, height: 30)
                .background(isSelected ? np_arsenic : np_white)
                .clipShape(Circle())
                .overlay(Circle().stroke(np_arsenic.opacity(0.3), lineWidth: 1))
        }
    }
}

// MARK: - RoutinesListView
struct RoutinesListView: View {
    @StateObject var routineManager = RoutineManager()
    @State private var showRoutineEntry = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    
                    Spacer()
                    
                    Button {
                        showRoutineEntry.toggle()
                    } label: {
                        VStack(alignment: .center) {
                            Text("+")
                                .font(.system(size: 17, weight: .heavy))
                                .textCase(.uppercase)
                                .kerning(2)
                                .textCase(.uppercase)
                            
                            Text("Routine")
                                .font(.system(size: 10, weight: .heavy))
                                .textCase(.uppercase)
                                .kerning(2)
                                .textCase(.uppercase)
                        }
                    }
                    .frame(width: 100, height: 50)
                    .background(np_white)
                    .foregroundColor(np_jap_indigo)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                
                VStack {
                    if routineManager.routines.isEmpty {
                        Text("No routines to display")
                            .foregroundStyle(np_white)
                            .fontWeight(.medium)
                            .textCase(.uppercase)
                            .kerning(2)
                            .padding()
                    } else {
                        ForEach(routineManager.routines) { routine in
                            RoutineCardView(routineManager: routineManager, routine: routine)
                                .foregroundStyle(np_white)
                                .fontWeight(.medium)
                                .textCase(.uppercase)
                                .kerning(2)
                                .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
            .sheet(isPresented: $showRoutineEntry) {
                AddRoutineView(routineManager: routineManager)
            }
            .sheet(isPresented: $routineManager.isEditingRoutine, onDismiss: {
                routineManager.stopEditing()
            }, content: {
                if let routineToEdit = routineManager.routineToEdit {
                    AddRoutineView(routineManager: routineManager, routineToEdit: routineToEdit)
                } else {
                    Text("Error: No routine to edit.")
                }
            })
        }
        .onAppear {
            routineManager.loadRoutines()
        }
    }
}


#Preview {
    let taskManager = TaskManager()
    let routineManager = RoutineManager()
    return RoutinesListView()
}
