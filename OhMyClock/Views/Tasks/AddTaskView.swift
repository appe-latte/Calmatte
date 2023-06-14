//
//  AddTaskView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-12.
//

import SwiftUI

struct AddTaskView: View {
    var onAdd: (TaskItem) -> ()
    
    @Environment(\.dismiss) private var dismiss
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskCategory: Category = .wellness
    
    // MARK: Animations
    @State private var animateColor: Color = Category.wellness.color
    @State private var animate: Bool = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(np_white)
                        .contentShape(Rectangle())
                }

                Text("Create New Task")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .kerning(3)
                    .textCase(.uppercase)
                    .frame(width: screenWidth - 20, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.vertical,15)
                
                TitleView("NAME")
                
                TextField("Make New Video", text: $taskName)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .kerning(2)
                    .textCase(.uppercase)
                    .frame(width: screenWidth - 20)
                    .tint(np_white)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(np_white.opacity(0.7))
                    .frame(height: 1)
                
                TitleView("DATE")
                    .padding(.top, 15)
                
                // MARK: Date + Time Pickers
                HStack(alignment: .bottom, spacing: 5) {
                    HStack {
                        Text(taskDate.toString("EE dd, MMM"))
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(2)
                            .textCase(.uppercase)
                            .frame(width: screenWidth * 0.35, alignment: .leading)
                        
                        Image(systemName: "calendar")
                            .font(.title3)
                            .foregroundColor(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate,displayedComponents: [.date])
                                    .blendMode(.destinationOver)
                            }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                    
                    HStack(spacing: 12){
                        Text(taskDate.toString("hh:mm a"))
                            .font(.footnote)
                            .fontWeight(.bold)
                            .kerning(2)
                            .textCase(.uppercase)
                            .frame(width: screenWidth * 0.35, alignment: .leading)
                    
                        Image(systemName: "clock")
                            .font(.title3)
                            .foregroundColor(np_white)
                            .overlay {
                                DatePicker("", selection: $taskDate,displayedComponents: [.hourAndMinute])
                                    .blendMode(.destinationOver)
                            }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                }
                .padding(.bottom, 15)
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
                TitleView("DESCRIPTION", np_black)
                
                TextField("About Your Task", text: $taskDescription)
                    .font(.caption)
                    .fontWeight(.bold)
                    .kerning(2)
                    .foregroundColor(np_black)
                    .textCase(.uppercase)
                    .frame(width: screenWidth - 20, alignment: .leading)
                    .padding(.top,2)
                
                Rectangle()
                    .fill(np_black.opacity(0.2))
                    .frame(height: 1)
                
                TitleView("CATEGORY", np_black)
                    .padding(.top,15)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: 20), count: 3),spacing: 15) {
                    ForEach(Category.allCases,id: \.rawValue){ category in
                        Text(category.rawValue.uppercased())
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(1)
                            .frame(width: screenWidth * 0.2, height: screenHeight * 0.1)
                            .hAlign(.center)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(category.color)
                            }
                            .foregroundColor(np_black)
                            .contentShape(Rectangle())
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
                    }
                }
                .padding(.top,5)
                
                Button {
                    // MARK: Creating Task & pass to callback
                    let task = TaskItem(dateAdded: taskDate, taskName: taskName, taskDescription: taskDescription, taskCategory: taskCategory)
                    onAdd(task)
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
                            Capsule()
                                .fill(np_black)
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
    func TitleView(_ value: String,_ color: Color = np_white.opacity(0.7)) -> some View {
        Text(value)
            .font(.caption)
            .fontWeight(.bold)
            .kerning(5)
            .textCase(.uppercase)
            .frame(width: screenWidth * 0.5, alignment: .leading)
            .foregroundColor(color)
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView { task in
            
        }
    }
}

