//
//  MoodDiaryView.swift
//  OhMyClock
//
//  Created by Nelson Gonzalez on 3/27/20.
//  Modified by: Stanford L. Khumalo (Appe Latte) 2023-07-11

import SwiftUI

struct MoodDiaryView : View {
    @ObservedObject var moodModelController = MoodModelController()
    @State var show = false
    @State var calenShow = false
    @State var txt = ""
    @State var docID = ""
    @State var remove = false
    
    @State private var diaryDescription = "Each day, jot down a short summary of your day and how you were feeling when the day was over."
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0){
                
                HeaderView()
                
                if self.moodModelController.moods.isEmpty {
                    background()
                } else {
                    let groupedMoods = Dictionary(grouping: self.moodModelController.moods) { (mood) -> Date in
                        let calendar = Calendar.current
                        return calendar.startOfDay(for: mood.date)
                    }.sorted { $0.key < $1.key } // Sort by date
                    
                    List {
                        ForEach(groupedMoods, id: \.key) { key, moods in
                            Section(header: Text("\(key, formatter: DateFormatter())")) {
                                ForEach(moods, id: \.id) { mood in
                                    MoodRowView(mood: mood)
                                        .listRowBackground(np_white)
                                        .padding(.vertical, 5)
                                }
                                .onDelete { (indexSet) in
                                    for index in indexSet {
                                        // Assuming moods are stored as an array
                                        if let i = self.moodModelController.moods.firstIndex(where: { $0.id == moods[index].id }) {
                                            self.moodModelController.deleteMood(at: IndexSet(integer: i))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .onAppear {
                        UITableView.appearance().tableFooterView = UIView() // Removes extra cells that are not being used.
                        
                        //MARK: Disable selection.
                        
                        UITableView.appearance().allowsSelection = true
                        UITableViewCell.appearance().selectionStyle = .none
                        UITableView.appearance().showsVerticalScrollIndicator = false
                        UITableViewCell.appearance().backgroundColor = UIColor(Color(red: 214 / 255, green: 26 / 255, blue: 60 / 255))
                    }
                    
                    Spacer()
                }
            }
            
            // MARK: Floating "Calendar" Button
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            self.txt = ""
                            self.docID = ""
                            self.calenShow.toggle()
                        } label: {
                            Circle()
                                .fill(np_white)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay {
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(np_jap_indigo)
                                        .padding(5)
                                }
                        }
                        .overlay(
                            Circle()
                                .stroke(np_jap_indigo, style: StrokeStyle(lineWidth: 1))
                                .padding(2)
                        )
                    }
                    .padding()
                }
            }
        }
        .background(background())
        .sheet(isPresented: self.$show) {
            MoodAddDiaryView(moodModelController: self.moodModelController)
        }
        .sheet(isPresented: self.$calenShow) {
            ZStack {
                MoodCalendarView(start: Date(), monthsToShow: 1, daysSelectable: true, moodController: moodModelController)
            }
            .ignoresSafeArea()
            .presentationDetents([.large, .fraction(0.85)])
        }
    }
    
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Image(background_theme)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [.clear, np_arsenic, np_arsenic], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height * 0.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            
            // Mask Tint
            Rectangle()
                .fill(np_arsenic).opacity(0.85)
                .frame(height: size.height)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: Day / Night Theme
    func getTime()->String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
    
    private var background_theme : String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<19:
            return "snow-mountain"
        default:
            return "mountain-pond"
        }
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Mood Journal")
                            .font(.title)
                            .fontWeight(.bold)
                            .kerning(2)
                            .minimumScaleFactor(0.5)
                            .textCase(.uppercase)
                            .foregroundColor(np_black)
                        
                        Spacer()
                        
                        // MARK: "Add + Diary" Button
                        Button {
                            self.txt = ""
                            self.docID = ""
                            self.show.toggle()
                        } label: {
                            HStack(spacing: 10){
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                
                                Text("Add")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .kerning(2)
                                    .textCase(.uppercase)
                            }
                            .padding(.vertical, 5)
                            .foregroundColor(np_white)
                            .frame(width: 100, height: 35)
                            .background(np_jap_indigo)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(np_white, style: StrokeStyle(lineWidth: 1))
                                    .padding(2)
                            )
                        }
                    }
                    
                    // MARK: Description
                    Text("\(diaryDescription)")
                        .font(.system(size: 10))
                        .kerning(3)
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_black)
                }
                .hAlign(.leading)
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
