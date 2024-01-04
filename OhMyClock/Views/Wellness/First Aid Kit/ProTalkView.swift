//
//  ProTalkView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-01-04.
//

import SwiftUI

struct ProTalkView: View {
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
                        .frame(width: width, height: 300)
                        .overlay {
                            Image("pro-talk")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 400)
                                .overlay {
                                    VStack(spacing: 5) {
                                        // MARK: Title
                                        HStack {
                                            Spacer()
                                            
                                            Text("Pro Talk")
                                                .font(.system(size: 27, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(3)
                                                .foregroundColor(np_black)
                                        }
                                        .padding(.horizontal, 20)
                                        
                                        Spacer()
                                            .frame(height: 50)
                                    }
                                    .padding(.vertical, 10)
                                }
                            
                        }
                        .clipShape(CustomHeaderShape())
                        .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15){
                            // MARK: Time for a Pro?
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Time for a Pro?", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_gray)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Recognizing the Need", isExpanded: $isSectionOneExpanded) {
                                        Text("If you or someone you know has been struggling consistently and it’s affecting daily life, it might be time to chat with a professional. This is especially true if there’s talk of self-harm or if the usual self-help tricks aren't cutting it.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_jap_indigo)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(.horizontal, 20)
                                    
                                    DisclosureGroup("It’s Okay to Seek Help", isExpanded: $isSectionTwoExpanded) {
                                        Text("Remember, reaching out to a mental health professional is as normal as seeing a doctor for a physical problem. It’s about taking care of your wellbeing.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_jap_indigo)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_gray)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: Who's Who in Mental Health
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Who's Who in Mental Health", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_gray)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Psychologists vs. Psychiatrists", isExpanded: $isSectionThreeExpanded) {
                                        Text("Psychologists help with therapy and counseling, while psychiatrists can also prescribe medication. Both are great resources for mental health support.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_jap_indigo)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(.horizontal, 20)
                                    
                                    DisclosureGroup("Counselors and Therapists", isExpanded: $isSectionFourExpanded) {
                                        Text("These pros are trained to listen and help you work through your feelings. They’re perfect for regular check-ins and talk therapy.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_jap_indigo)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(.horizontal, 20)
                                    
                                    DisclosureGroup("Social Workers", isExpanded: $isSectionFiveExpanded) {
                                        Text("They often work in mental health too, offering counseling and connecting you with community resources.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_jap_indigo)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_gray)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: Finding Help
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Finding Help", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_gray)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Start with a GP", isExpanded: $isSectionSixExpanded) {
                                        Text("Your General Practitioner (GP) or family doctor is a good starting point. They can make referrals to mental health specialists.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_jap_indigo)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(.horizontal, 20)
                                    
                                    DisclosureGroup("School and Work Resources", isExpanded: $isSectionSevenExpanded) {
                                        Text("If you’re a student, check out your school’s counseling services. Many workplaces also have employee assistance programs for mental health support")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_jap_indigo)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(.horizontal, 20)
                                    
                                    DisclosureGroup("Online Directories", isExpanded: $isSectionEightExpanded) {
                                        Text("Websites like Psychology Today have directories of therapists and psychiatrists, including their specialties and contact info.")
                                            .font(.system(size: 12))
                                            .fontWeight(.medium)
                                            .foregroundColor(np_jap_indigo)
                                    }
                                    .font(.system(size: 13))
                                    .fontWeight(.semibold)
                                    .kerning(1)
                                    .textCase(.uppercase)
                                    .foregroundColor(np_jap_indigo)
                                    .padding(.horizontal, 20)
                                }
                                .padding(20)
                                .background(np_gray)
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
            
            Image("img-bg")
                .resizable()
                .scaledToFill()
                .frame(height: size.height, alignment: .bottom)
            
            Rectangle()
                .fill(np_green)
                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProTalkView()
}
