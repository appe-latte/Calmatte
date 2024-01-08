//
//  SelfCareView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-01-04.
//

import SwiftUI

struct SelfCareView: View {
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
    @State private var isSectionElevenExpanded = false
    @State private var isSectionTwelveExpanded = false
    @State private var isSectionThirteenExpanded = false
    @State private var isSectionFourteenExpanded = false
    
    @State var rowHeight = 40.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    CustomHeaderShape()
                        .frame(width: width, height: 300)
                        .overlay {
                            Image("self-care")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 400)
                                .overlay {
                                    VStack(spacing: 5) {
                                        // MARK: Title
                                        HStack {
                                            Spacer()
                                            
                                            Text("Keepin' It Steady")
                                                .font(.system(size: 23, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(3)
                                                .foregroundColor(np_white)
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
                            // MARK: Everyday Mind Fitness
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Everyday Mind Fitness", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Routine is Key", isExpanded: $isSectionOneExpanded) {
                                        Text("Establish a daily routine that includes time for work, relaxation, and activities you enjoy. A consistent routine can provide a sense of normalcy and control.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Journaling", isExpanded: $isSectionTwoExpanded) {
                                        Text("Keep a daily journal. Writing down your thoughts and feelings can help you understand them more clearly and reduce stress.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Learning New Skills", isExpanded: $isSectionThreeExpanded) {
                                        Text("Picking up a new hobby or skill can be incredibly rewarding and a great distraction from everyday stress.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
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
                            
                            // MARK: Your Crew Matters
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Your Crew Matters", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Nurturing Relationships", isExpanded: $isSectionFourExpanded) {
                                        Text("Spend quality time with people who uplift you. Good conversations with friends or family can be incredibly therapeutic.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Join Groups or Clubs", isExpanded: $isSectionFiveExpanded) {
                                        Text("Engaging in social activities or clubs can help you connect with others who share similar interests, providing a sense of belonging and community.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Asking for Help", isExpanded: $isSectionSixExpanded) {
                                        Text("Don’t be afraid to reach out for support from your network when you need it. Remember, it’s okay to not be okay.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
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
                            
                            // MARK: Breaking the Silence
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Breaking the Silence", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Talk About It", isExpanded: $isSectionSevenExpanded) {
                                        Text("Open up about your mental health experiences. Sharing your story can inspire others to do the same and help break down stigma.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Educate Yourself and Others", isExpanded: $isSectionEightExpanded) {
                                        Text("Learn more about mental health and share your knowledge with others. This can help create a more understanding and supportive environment.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Advocacy and Volunteering", isExpanded: $isSectionNineExpanded) {
                                        Text("Consider volunteering for mental health causes or participating in advocacy efforts. This can be empowering and give you a sense of purpose.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
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
                            
                            // MARK: Embracing Self-Care
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Embracing Self-Care", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Self-Care Practices", isExpanded: $isSectionTenExpanded) {
                                        Text("Incorporate self-care into your daily life. This could be as simple as taking a relaxing bath, reading a book, or practicing meditation.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Physical & Mental Health", isExpanded: $isSectionElevenExpanded) {
                                        Text("Remember that physical health plays a crucial role in mental health. Eat nutritious foods, exercise regularly, and get enough sleep.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Digital Breaks", isExpanded: $isSectionTwelveExpanded) {
                                        Text("Take regular breaks from digital devices to avoid information overload and reduce stress.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
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
                            
                            // MARK: Reflect and Recharge
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Reflect and Recharge", systemImage: "")
                                        .font(.system(size:  16, weight: .heavy, design: .rounded))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_jap_indigo)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Reflect on Progress", isExpanded: $isSectionThirteenExpanded) {
                                        Text("Regularly take time to reflect on your mental health journey and acknowledge your progress, no matter how small.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
                                            .foregroundColor(np_beige)
                                    }
                                    .font(.system(size:  15, weight: .heavy, design: .rounded))
                                    .kerning(1)
                                    .foregroundColor(np_white)
                                    .padding(.horizontal, 20)
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Relaxation Techniques", isExpanded: $isSectionFourteenExpanded) {
                                        Text("Learn and practice relaxation techniques such as deep breathing, progressive muscle relaxation, or guided imagery.")
                                            .font(.system(size:  13, weight: .medium, design: .rounded))
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
    SelfCareView()
}
