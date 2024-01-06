//
//  DiyCalmView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-01-04.
//

import SwiftUI

struct DiyCalmView: View {
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
    
    @State var rowHeight = 40.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    CustomHeaderShape()
                        .stroke(np_black, lineWidth: 50)
                        .frame(width: width, height: 300)
                        .overlay {
                            Image("diy-calm")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 400)
                                .overlay {
                                    VStack(spacing: 5) {
                                        // MARK: Title
                                        HStack {
                                            Spacer()
                                            
                                            Text("DIY Calm")
                                                .font(.system(size: 23, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(3)
                                                .foregroundColor(np_white)
                                                .padding(5)
                                                .background(np_jap_indigo)
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
                            // MARK: Breathe Easy
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Breathe Easy", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Chill with Your Breath", isExpanded: $isSectionOneExpanded) {
                                        Text("Learn how to use your breath to calm your mind. Try deep breathing exercises – inhale slowly for four counts, hold it for four, and exhale for four. It's like a remote control for chilling out your brain.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Bubble Breathing", isExpanded: $isSectionTwoExpanded) {
                                        Text("Imagine you're blowing bubbles. Slow and steady. It's a fun way to focus on your breath and push away stress.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_jap_indigo)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: Mindful Moments
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Mindful Moments", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("What's Mindfulness?", isExpanded: $isSectionThreeExpanded) {
                                        Text("It's all about living in the now. Not stressing about tomorrow's math test or that awkward thing you said yesterday.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Quick Mindfulness Exercise", isExpanded: $isSectionFourExpanded) {
                                        Text("Try this – spend 5 minutes noticing everything around you. The sounds, the sights, how your feet feel on the ground. It's like hitting the pause button on life's craziness.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Daily Mindfulness Habit", isExpanded: $isSectionFiveExpanded) {
                                        Text("Make it a habit. Maybe take a minute every morning to just sit and be. It's a game-changer for starting your day on a positive note.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_jap_indigo)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: Stay Grounded
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Stay Grounded", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Feet On THe Floor", isExpanded: $isSectionSixExpanded) {
                                        Text("When things feel too much, plant your feet firmly on the ground. Feel the floor beneath you. It's a quick way to bring you back to the present.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("The 5-4-3-2-1 Game", isExpanded: $isSectionSevenExpanded) {
                                        Text("Spot 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste. It's a cool trick to distract your brain from panic or anxiety.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Power of Music", isExpanded: $isSectionEightExpanded) {
                                        Text("Create a playlist of tunes that lift you up or calm you down. Music can be a powerful ally when your mind's in overdrive.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_jap_indigo)
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
                    .background(Circle().fill(np_jap_indigo))
            })
        }
    }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Rectangle()
                .fill(LinearGradient(colors: [np_tangerine, np_pink, np_pink], startPoint: .top, endPoint: .bottom))
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    DiyCalmView()
}
