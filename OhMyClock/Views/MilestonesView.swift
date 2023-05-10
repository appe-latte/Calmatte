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
    @State private var milestoneDescription = "Make a short list of achievable milestones for the day."
    @State private var showAddTasksView = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack(alignment: .bottom) {
            np_white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // MARK: "Display milestone items"
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
                }
                
                VStack(spacing: 20) {
                    // MARK: Milestone title + "Add" button
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Milestones")
                                .font(.title3)
                                .fontWeight(.bold)
                                .kerning(10)
                                .textCase(.uppercase)
                                .minimumScaleFactor(0.6)
                                .lineLimit(1)
                            
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
                            .padding(2)
                            .foregroundColor(np_black)
                            .frame(width: 125, height: 35)
                            .background(np_white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(np_black, style: StrokeStyle(lineWidth: 1))
                                    .padding(2)
                            )
                        }
                        
                        // MARK: Description
                        Text("\(milestoneDescription)")
                            .font(.footnote)
                            .kerning(3)
                            .textCase(.uppercase)
                            .minimumScaleFactor(0.5)
                    }
                    .foregroundColor(np_white)
                    .padding(20)
                }
                .frame(height: screenHeight * 0.20)
                .background(np_black)
                .cornerRadius(15, corners: [.topLeft, .topRight])
            }
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

struct MilestonesView_Previews: PreviewProvider {
    static var previews: some View {
        MilestonesView()
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

