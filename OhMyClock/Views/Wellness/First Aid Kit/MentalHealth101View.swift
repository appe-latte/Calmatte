//
//  MentalHealth101View.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-01-03.
//

import SwiftUI

struct MentalHealth101View: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @State var rowHeight = 40.0
    
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    CustomHeaderShape()
                        .frame(width: width, height: 300)
                        .overlay {
                            Image("img-sunrise")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 400)
                                .overlay {
                                    VStack(spacing: 5) {
                                        // MARK: Title
                                        HStack {
                                            Spacer()
                                            
                                            Text("What's Up with Mental Health?")
                                                .font(.system(size: 23, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(3)
                                                .foregroundColor(np_black)
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
                            // MARK: Mental Health 101
                            VStack(spacing: 15) {
                                HStack(alignment: .center, spacing: 5) {
                                    Label("Mental Health 101", systemImage: "info.circle.fill")
                                        .font(.system(size: 16))
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_white)
                                }
                                
                                DisclosureGroup("What's Mental Health?", isExpanded: $isSectionOneExpanded) {
                                    Text("Think of it like this – mental health is all about how you handle your emotions, respond to stress, and deal with everyday life. Just like we work out to keep our bodies fit, our minds need a bit of TLC too.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                
                                DisclosureGroup("Why it matters?", isExpanded: $isSectionTwoExpanded) {
                                    Text("Your mental health influences how you think, feel, and behave. It's a big deal because it impacts your ability to make decisions, build relationships, and generally enjoy life.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            }
                            .padding(.bottom, 10)
                            
                            // MARK: Common Vibes
                            VStack(spacing: 25) {
                                HStack(alignment: .center, spacing: 5) {
                                    Label("Common Vibes", systemImage: "info.circle.fill")
                                        .font(.system(size: 16))
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                
                                DisclosureGroup("Anxiety", isExpanded: $isSectionThreeExpanded) {
                                    Text("Ever felt like your brain's a running engine that won't turn off? That's anxiety. It's when worry and stress are like unwanted guests in your head.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                
                                DisclosureGroup("Depression", isExpanded: $isSectionFourExpanded) {
                                    Text("This is more than just a bad day; it's feeling down or losing interest in things you used to enjoy, and it can feel like walking through mud.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                
                                DisclosureGroup("Stress", isExpanded: $isSectionFiveExpanded) {
                                    Text("It's like when your brain is juggling a million balls at once. A bit of stress is normal, but too much can feel overwhelming.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                
                                DisclosureGroup("Mood Swings", isExpanded: $isSectionSixExpanded) {
                                    Text("One minute you're up, the next you're down. If these swings are extreme, they can really mess with your day-to-day life.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                            }
                            .padding(.bottom, 10)
                            
                            // MARK: Spotting The Signs
                            VStack(spacing: 25) {
                                HStack(alignment: .center, spacing: 5) {
                                    Label("Spotting The Signs", systemImage: "info.circle.fill")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                
                                DisclosureGroup("In Yourself", isExpanded: $isSectionSevenExpanded) {
                                    Text("Notice if you're feeling more down, worried, or stressed than usual. Changes in sleep, appetite, or energy levels are clues too. If you're finding it hard to enjoy things you normally would, that's a sign.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                
                                DisclosureGroup("In Friends", isExpanded: $isSectionEightExpanded) {
                                    Text("They might seem more withdrawn, irritable, or just not themselves. Maybe they're not hanging out as much or have stopped doing things they love.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
                                
                                DisclosureGroup("What's Normal?", isExpanded: $isSectionNineExpanded) {
                                    Text("Everyone has off days, but if these feelings stick around for a while or start to really get in the way of life, it's time to take them seriously.")
                                        .font(.system(size: 9))
                                        .fontWeight(.medium)
                                }
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                                .foregroundColor(np_white)
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
                    .foregroundColor(np_jap_indigo)
                    .padding(10)
                    .background(Circle().fill(np_white))
            })
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
        .ignoresSafeArea(.all)
    }
}

#Preview {
    MentalHealth101View()
}
