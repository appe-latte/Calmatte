//
//  TasksView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import Foundation
import RealmSwift

struct TasksView: View {
    @EnvironmentObject var realmManager : OmcRealmManager
    @State private var showAddTasksView = false
    
    let screenHeight = UIScreen.main.bounds.height
    
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
                
                // MARK: Milestone List
                
                List {
                    ForEach(realmManager.milestones, id: \.id) { milestone in
                        if !milestone.isInvalidated {
                            TaskRow(task: milestone.title, completed: milestone.completed)
                                .onTapGesture {
                                    realmManager.updateMilestone(id: milestone.id, completed: !milestone.completed)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        realmManager.deleteMilestone(id: milestone.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .onAppear {
                    UITableView.appearance().backgroundColor = UIColor(Color(red: 247 / 255, green: 246 / 255, blue: 242 / 255))
                    
                    UITableViewCell.appearance().backgroundColor = UIColor(Color(red: 247 / 255, green: 246 / 255, blue: 242 / 255))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(np_black)
        }
        .blurredSheet(.init(.thickMaterial), show: $showAddTasksView) {
            //
        } content: {
            if #available(iOS 16.0, *) {
                AddTasksView()
                    .environmentObject(realmManager)
                    .preferredColorScheme(.light)
                    .presentationDetents([.height(screenHeight / 2.5), .fraction(0.4)])
            } else {
                // Fallback on earlier versions
                AddTasksView()
                    .environmentObject(realmManager)
                    .colorScheme(.light)
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
            .environmentObject(OmcRealmManager())
    }
}

// MARK: "Add New Task" button

struct addTaskButton : View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, alignment: .center)
                .foregroundColor(np_black)
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
