//
//  HelpSquadView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-01-04.
//

import SwiftUI

struct HelpSquadView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    // Disclosure Group declarations
    @State private var isSectionOneExpanded = false
    @State private var isSectionTwoExpanded = false
    @State private var isSectionThreeExpanded = false
    @State private var isSectionFourExpanded = false
    @State private var isSectionFiveExpanded = false
    @State private var isSectionSixExpanded = false
    @State private var isSectionSevenExpanded = false
    @State private var isSectionEightExpanded = false
    @State private var isSectionNineExpanded = false
    @State private var isSectionTenExpanded = false
    
    @State var rowHeight = 40.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    CustomHeaderShape()
                        .frame(width: width, height: 300)
                        .overlay {
                            Image("help-squad")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 400)
                                .overlay {
                                    VStack(spacing: 5) {
                                        // MARK: Title
                                        HStack {
                                            Spacer()
                                            
                                            Text("Helping Your Squad")
                                                .font(.system(size: 22, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(3)
                                                .foregroundColor(np_beige)
                                                .padding(5)
                                                .background(np_arsenic)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .padding(.bottom, 10)
                                        }
                                        .padding(.horizontal, 20)
                                        
                                        Spacer()
                                            .frame(height: 150)
                                    }
                                    .padding(.vertical, 10)
                                }
                            
                        }
                        .clipShape(CustomHeaderShape())
                        .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15){
                            // MARK: How To Chat
                            VStack {
                                HStack(spacing: 5) {
                                    Label("How To Chat", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Finding the Right Moment", isExpanded: $isSectionOneExpanded) {
                                        Text("Pick a chill time to talk. Maybe during a walk or a relaxed hangout. Start with, 'Hey, I've noticed you've been a bit down. Want to talk about it?'")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("What to Say", isExpanded: $isSectionTwoExpanded) {
                                        Text("Keep it real but gentle. Try, 'I'm here for you,' or 'It's totally okay to feel this way.' Avoid clichés like, 'Cheer up,' or 'It could be worse.'")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_arsenic)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: Listen Like a Pro
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Listen Like a Pro", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Full Attention Mode", isExpanded: $isSectionThreeExpanded) {
                                        Text("When they talk, really listen. Put your phone away. Nod, make eye contact – show you're all ears.")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Reflect and Validate", isExpanded: $isSectionFourExpanded) {
                                        Text("Sometimes, just saying, 'That sounds really tough,' or 'I can see why you'd feel that way,' means a lot.")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("No Judging, Just Listening", isExpanded: $isSectionFiveExpanded) {
                                        Text("It's not about giving advice or fixing things. It's about being there and letting them vent.")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_arsenic)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: Offering Support, Not Smothering
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Offering Support, Not Smothering", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Small Gestures Count", isExpanded: $isSectionSixExpanded) {
                                        Text("Sometimes it's the little things – sending a meme, a text, or just hanging out.")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Encourage, Don't Push", isExpanded: $isSectionSevenExpanded) {
                                        Text("Suggest they talk to someone who can help, like a counselor, but don’t force it. Say, 'Have you thought about talking to someone professional about this?'")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Respect Their Space", isExpanded: $isSectionEightExpanded) {
                                        Text("If they're not ready to open up, that's cool. Just let them know you're there when they are.")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_arsenic)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: When to Step Up
                            VStack {
                                HStack(spacing: 5) {
                                    Label("When to Step Up", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Red Flags", isExpanded: $isSectionNineExpanded) {
                                        Text("If they talk about self-harm or seem really down, it's more than just being a good listener. Encourage them to seek professional help.")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Staying Safe", isExpanded: $isSectionTenExpanded) {
                                        Text("If you ever think they're in immediate danger, it’s okay to reach out for more help – like a trusted adult or even emergency services.")
                                            .font(.system(size: 13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_arsenic)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
            .background(background())
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(np_white)
                    .padding(10)
                    .background(Circle().fill(np_arsenic))
            })
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(LinearGradient(colors: [np_purple, np_purple, np_deep_purple], startPoint: .top, endPoint: .bottom))
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HelpSquadView()
}
