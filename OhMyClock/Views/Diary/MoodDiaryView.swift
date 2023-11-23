//
//  MoodDiaryView.swift
//  OhMyClock
//
//  Created by Nelson Gonzalez on 3/27/20.
//  Modified by: Stanford L. Khumalo (Appe Latte) 2023-07-11

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct MoodDiaryView : View {
    @ObservedObject var moodModelController = MoodModelController()
    @State var txt = ""
    @State var docID = ""
    @State var remove = false
    
    // MARK: Bottom sheets
    @State var show = false
    @State var calenShow = false
    
    @State private var diaryDescription = "Each day, jot down a short summary of your day and how you were feeling when the day was over."
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                HeaderView()
                
                // MARK: List View + Settings
                if self.moodModelController.moods.isEmpty {
                    background()
                } else {
                    let groupedMoods = Dictionary(grouping: self.moodModelController.moods) { (mood) -> Date in
                        let calendar = Calendar.current
                        return calendar.startOfDay(for: mood.date)
                    }.sorted { $0.key > $1.key } // Reverse sort by date
                    
                    List {
                        ForEach(groupedMoods.indices, id: \.self) { outerIndex in
                            Section {
                                ForEach(groupedMoods[outerIndex].value.reversed(), id: \.id) { mood in
                                    MoodRowView(mood: mood)
                                        .listRowBackground(np_arsenic)
                                }
                                .onDelete { indexSet in
                                    indexSet.forEach { index in
                                        let mood = groupedMoods[outerIndex].value.reversed()[index]
                                        self.moodModelController.deleteMood(withID: mood.id)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .environment(\.defaultMinListRowHeight, 150)
                    .padding(.bottom, 5)
//                    .shadow(color: np_white, radius: 0.1, x: 5, y: 5)
                    .onAppear {
                        UITableView.appearance().tableFooterView = UIView() // Removes extra cells that are not being used.
                        
                        // MARK: Disable selection.
                        UITableView.appearance().allowsSelection = true
                        UITableViewCell.appearance().selectionStyle = .none
                        UITableView.appearance().showsVerticalScrollIndicator = false
                        UITableViewCell.appearance().backgroundColor = UIColor(Color(red: 214 / 255, green: 26 / 255, blue: 60 / 255))
                    }
                    
                    Spacer()
                }
            }
        }
        .background(background())
        .sheet(isPresented: self.$show) {
            MoodAddDiaryView(moodModelController: self.moodModelController)
        }
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
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Mood Timeline")
                            .font(.custom("Butler", size: 27))
                            .minimumScaleFactor(0.5)
                            .foregroundColor(np_white)
                        
                        Spacer()
                        
                        // MARK: "Add + Diary" Button
                        Button(action: {
                            self.txt = ""
                            self.docID = ""
                            self.show.toggle()
                        }, label: {
                            Image("add")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .foregroundColor(np_white)
                                .padding(5)
                        })
                        .frame(width: 40, height: 40)
                        .padding(5)
                    }
                    
                    // MARK: Description
                    Text("\(diaryDescription)")
                        .font(.custom("Butler", size: 16))
                        .kerning(3)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_gray)
                }
                .hAlign(.leading)
            }
        }
        .padding(15)
        .background {
            VStack(spacing: 0) {
                np_jap_indigo
            }
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
        }
    }
}

class Host : UIHostingController<ContentView>{
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

struct MoodDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        MoodDiaryView()
    }
}
