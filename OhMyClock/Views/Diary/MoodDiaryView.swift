//
//  MoodDiaryView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import SwiftUI

struct MoodDiaryView : View {
    @ObservedObject var moodModelController = MoodModelController()
    @State var show = false
    @State var txt = ""
    @State var docID = ""
    @State var remove = false
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0){
                
                HeaderView()
                
                if self.moodModelController.moods.isEmpty {
                    background() // to make it cover the full screen
                } else {
                    List {
                        ForEach(self.moodModelController.moods, id: \.id) { mood in
                            
                            MoodRowView(mood: mood)
                                .listRowBackground(np_white)
                                .padding(.vertical, 10)
                            
                        }
                        .onDelete { (index) in
                            
                            self.moodModelController.deleteMood(at: index)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .onAppear {
                        //Removes extra cells that are not being used.
                        UITableView.appearance().tableFooterView = UIView()
                        
                        //MARK: Disable selection.
                        
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
                    Text("Today")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .kerning(5)
                        .minimumScaleFactor(0.5)
                        .textCase(.uppercase)
                        .foregroundColor(np_black)
                    
                    Text(Date().formatted(.dateTime.month().day().year()))
                        .font(.title3)
                        .fontWeight(.bold)
                        .kerning(5)
                        .textCase(.uppercase)
                        .foregroundColor(np_black)
                    
                    // MARK: Description
                    //                    Text("\(milestoneDescription)")
                    //                        .font(.system(size: 10))
                    //                        .kerning(3)
                    //                        .textCase(.uppercase)
                    //                        .minimumScaleFactor(0.5)
                    //                        .foregroundColor(np_black)
                }
                .hAlign(.leading)
                
                // MARK: "Add + Diary" Button
                Button {
                    self.txt = ""
                    self.docID = ""
                    self.show.toggle()
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
                    .background(np_arsenic)
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
}

class Host : UIHostingController<ContentView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MoodDiaryView()
    }
}
