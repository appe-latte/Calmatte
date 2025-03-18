//
//  WellnessView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-25.
//

import AVKit
import Lottie
import Combine
import SwiftUI

struct WellnessView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var moodModel: MoodModel
    @ObservedObject var moodModelController = MoodModelController()
    @StateObject var progressView = AppViewModel()
    @State var dragOffset: CGFloat = 0
    
    @State private var wellnessDescription = "Embrace this sanctuary of sound and support, designed for your journey towards inner peace and balance."
    @State private var showPlayer = false
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @State var showDiySheet = false
    @State var show101Sheet = false
    @State var showSquadHelpSheet = false
    @State var showGetRealSheet = false
    @State var showProTalkSheet = false
    @State var showSelfCareSheet = false
    
    @State var showMonthSheet = false
    
    let meditationViewModel = MeditationViewModel(meditation: Meditation.data)
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // MARK: Background
                background()
                
                VStack {
                    HeaderView()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        // MARK: Anxiety Test + Meditation Zone
                        HStack(spacing: 10) {
                            // MARK: Wellness Audio View
                            NavigationLink(destination: WellnessAudioView()){
                                HStack {
                                    Text("Wellness Audio")
                                        .font(.system(size:  14, weight: .bold, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                        .padding(5)
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: 175, height: 100)
                            .background(np_white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            // MARK: Meditation View
                            NavigationLink(destination: MeditationView(meditationViewModel: meditationViewModel)){
                                HStack {
                                    Text("Meditation Zone")
                                        .font(.system(size:  14, weight: .bold, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                        .padding(5)
                                }
                                .padding(.horizontal)
                            }
                            .frame(width: 175, height: 100)
                            .background(np_white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        
                        Spacer()
                            .frame(height: 30)
                        
                        // MARK: Mental Health First Kit
                        VStack(spacing: 10) {
                            HStack {
                                Text("Mental Health First Aid Kit")
                                    .font(.system(size:  14, weight: .bold, design: .rounded))
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(5)
                                    .background(np_white)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            NavigationStack {
                                Group {
                                    VStack(spacing: 15) {
                                        // MARK: Mental Health 101
                                        Button(action: {
                                            show101Sheet.toggle()
                                        },
                                               label: {
                                            HStack(spacing: 10) {
                                                Text("Mental Health 101")
                                                    .font(.system(size:  14, weight: .semibold, design: .rounded))
                                                    .kerning(1)
                                                    .textCase(.uppercase)
                                                    .foregroundColor(np_beige)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                            }
                                            .padding(.horizontal, 10)
                                        })
                                        .font(.system(size:  14, weight: .medium, design: .rounded))
                                        .foregroundColor(np_beige)
                                        
                                        Divider()
                                            .background(np_gray)
                                        
                                        // MARK: DIY Calm
                                        Button(action: {
                                            showDiySheet.toggle()
                                        },
                                               label: {
                                            HStack(spacing: 10) {
                                                Text("DIY Calm")
                                                    .font(.system(size:  14, weight: .semibold, design: .rounded))
                                                    .kerning(1)
                                                    .textCase(.uppercase)
                                                    .foregroundColor(np_beige)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                            }
                                            .padding(.horizontal, 10)
                                        })
                                        .font(.system(size:  14, weight: .medium, design: .rounded))
                                        .foregroundColor(np_beige)
                                        
                                        Divider()
                                            .background(np_gray)
                                        
                                        // MARK: Helping Your Squad
                                        Button(action: {
                                            showSquadHelpSheet.toggle()
                                        },
                                               label: {
                                            HStack(spacing: 10) {
                                                Text("Helping Your Squad")
                                                    .font(.system(size:  14, weight: .semibold, design: .rounded))
                                                    .kerning(1)
                                                    .textCase(.uppercase)
                                                    .foregroundColor(np_beige)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                            }
                                            .padding(.horizontal, 10)
                                        })
                                        .font(.system(size:  14, weight: .medium, design: .rounded))
                                        .foregroundColor(np_beige)
                                        
                                        Divider()
                                            .background(np_gray)
                                        
                                        // MARK: When Things Get Real
                                        Button(action: {
                                            showGetRealSheet.toggle()
                                        },
                                               label: {
                                            HStack(spacing: 10) {
                                                Text("When Things Get Real")
                                                    .font(.system(size:  14, weight: .semibold, design: .rounded))
                                                    .kerning(1)
                                                    .textCase(.uppercase)
                                                    .foregroundColor(np_beige)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                            }
                                            .padding(.horizontal, 10)
                                        })
                                        .font(.system(size:  14, weight: .medium, design: .rounded))
                                        .foregroundColor(np_beige)
                                        
                                        Divider()
                                            .background(np_gray)
                                        
                                        // MARK: Pro Talk
                                        Button(action: {
                                            showProTalkSheet.toggle()
                                        },
                                               label: {
                                            HStack(spacing: 10) {
                                                Text("Pro Talk")
                                                    .font(.system(size:  14, weight: .semibold, design: .rounded))
                                                    .kerning(1)
                                                    .textCase(.uppercase)
                                                    .foregroundColor(np_beige)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                            }
                                            .padding(.horizontal, 10)
                                        })
                                        .font(.system(size: 14))
                                        .fontWeight(.medium)
                                        .foregroundColor(np_beige)
                                        
                                        Divider()
                                            .background(np_gray)
                                        
                                        // MARK: Keepin' It Steady
                                        Button(action: {
                                            showSelfCareSheet.toggle()
                                        },
                                               label: {
                                            HStack(spacing: 10) {
                                                Text("Keepin' It Steady")
                                                    .font(.system(size:  14, weight: .semibold, design: .rounded))
                                                    .kerning(1)
                                                    .textCase(.uppercase)
                                                    .foregroundColor(np_beige)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                            }
                                            .padding(.horizontal, 10)
                                        })
                                        .font(.system(size:  14, weight: .medium, design: .rounded))
                                        .foregroundColor(np_beige)
                                    }
                                }
                            }
                            .padding(20)
                            .background(np_jap_indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(20)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: self.$showDiySheet) {
            DiyCalmView()
        }
        .sheet(isPresented: self.$show101Sheet) {
            MentalHealth101View()
        }
        .sheet(isPresented: self.$showSquadHelpSheet) {
            HelpSquadView()
        }
        .sheet(isPresented: self.$showGetRealSheet) {
            GettingRealView()
        }
        .sheet(isPresented: self.$showProTalkSheet) {
            ProTalkView()
        }
        .sheet(isPresented: self.$showSelfCareSheet) {
            SelfCareView()
        }
        .sheet(isPresented: self.$showMonthSheet) {
            AnalyticsView(start: Date(), monthsToShow: 2, moodController: MoodModelController()).environmentObject(moodModelController).onAppear {
                progressView.loadData() }
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(np_arsenic)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
    
    // MARK: "Header View"
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Calmatte")
                        .font(.custom("Butler", size: 20))
                        .minimumScaleFactor(0.5)
                        .kerning(2)
                        .foregroundColor(np_white)
                    
                    Text("Wellness")
                        .font(.custom("Butler", size: 27))
                        .textCase(.uppercase)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(np_white)
                }
                
                Spacer()
                
                // MARK: "Month View" Button
                Button {
                    showMonthSheet.toggle()
                } label: {
                    VStack(alignment: .center) {
                        Text("Month")
                            .font(.system(size: 10, weight: .bold))
                        
                        Text("View")
                            .font(.system(size: 10, weight: .bold))
                    }
                }
                .frame(width: 45, height: 45)
                .background(np_white)
                .foregroundColor(np_jap_indigo)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(width: width - 20)
            .hAlign(.leading)
            
            // MARK: Description
            Text("\(wellnessDescription)")
                .font(.system(size: 13, weight: .medium))
                .kerning(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(np_gray)
            
            Divider()
                .background(np_gray)
                .padding(.top, 15)
        }
        .padding(15)
    }
    
    // MARK: - 3 Month View
    struct LastMonthView: View {
        @ObservedObject var moodModelController: MoodModelController
        var month: Month
        let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
        let colors = DiaryColors()
        
        var body: some View {
            ZStack {
                VStack {
                    
                    // MARK: Month Title
                    HStack {
                        Text("\(month.monthNameYear)")
                            .font(.custom("Butler", size: 24))
                            .textCase(.uppercase)
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // MARK: Weekdays
                    HStack {
                        GridStack(rows: 1, columns: 7) { row, col in
                            Text(weekdays[col])
                                .font(.custom("Butler", size: 18))
                                .foregroundColor(np_white)
                        }
                    }
                    
                    // MARK: Calendar days grid
                    GridStack(rows: month.monthRows, columns: month.monthDays.count) { row, col in
                        if month.monthDays[col+1]![row].dayDate == Date(timeIntervalSince1970: 0) {
                            Text("")
                                .frame(width: 20, height: 20)
                        } else {
                            DayCellView(moodModelController: moodModelController,
                                        day: month.monthDays[col+1]![row])
                        }
                    }
                    .font(.custom("Butler", size: 20))
                }
                .padding(.bottom, 10)
            }
            .background(np_arsenic)
        }
    }
}
