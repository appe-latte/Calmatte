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

struct JournalView : View {
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
                                        .listRowBackground(np_arsenic.opacity(0.1))
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
                    .listStyle(InsetListStyle())
                    .scrollContentBackground(.hidden)
                    .environment(\.defaultMinListRowHeight, 150)
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
            LogMoodView(moodModelController: self.moodModelController)
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
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                // MARK: View Title
                VStack(alignment: .leading) {
                    Text("Mood")
                        .font(.custom("Butler", size: 23))
                        .minimumScaleFactor(0.5)
                        .kerning(2)
                        .foregroundColor(np_white)
                    
                    Text("Timeline")
                        .font(.custom("Butler", size: 30))
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_white)
                }
                
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
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .kerning(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(np_gray)
            
            Divider()
                .background(np_gray)
                .padding(.top, 15)
        }
        .hAlign(.leading)
        .padding(15)
    }
}

class Host : UIHostingController<ContentView>{
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

struct MoodDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
