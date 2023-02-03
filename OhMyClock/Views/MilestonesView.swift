//
//  MilestonesView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-11.
//

import SwiftUI
import Foundation
import RealmSwift

struct MilestonesView: View {
    @EnvironmentObject var realmManager : OmcRealmManager
    @State private var showAddTasksView = false
    
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                // MARK: "Heading"
                
                HStack {
                    Text("Daily Milestones")
                        .font(.title3)
                        .fontWeight(.bold)
                        .kerning(7)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.75)
                        .foregroundColor(np_white)
                    
                    Spacer()
                    
                    Button(action: {
                        showAddTasksView.toggle()
                    }, label: {
                        Text("+Add")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(5)
                            .textCase(.uppercase)
                    })
                    .padding(.vertical, 5)
                    .foregroundColor(np_black)
                    .frame(width: 75, height: 35)
                    .background(np_white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(np_black, style: StrokeStyle(lineWidth: 1))
                            .padding(2)
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                
                // MARK: "Description"
                
                HStack {
                    Text("Make a short list of achievable milestones for the day.")
                        .font(.footnote)
                        .kerning(7)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.75)
                        .foregroundColor(np_white)
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
        MilestonesView()
            .environmentObject(OmcRealmManager())
    }
}

// MARK: "Add New Task" button

struct addTaskButton : View {
    var body: some View {
        ZStack {
            Rectangle()
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
        .frame(height: 40, alignment: .center)
        .overlay(
            Circle()
                .stroke(np_white, style: StrokeStyle(lineWidth: 1))
                .padding(2)
        )
    }
}
