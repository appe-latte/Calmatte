//
//  GettingRealView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2024-01-04.
//

import SwiftUI

struct GettingRealView: View {
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
    
    @State var rowHeight = 40.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    CustomHeaderShape()
                        .frame(width: width, height: 300)
                        .overlay {
                            Image("get-real")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 400)
                                .overlay {
                                    VStack(spacing: 5) {
                                        // MARK: Title
                                        HStack {
                                            Spacer()
                                            
                                            Text("When Things Get Real")
                                                .font(.system(size: 21, design: .rounded))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                                .kerning(3)
                                                .foregroundColor(np_white)
                                                .padding(5)
                                                .background(np_red)
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
                            // MARK: Crisis Management
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Crisis Management", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_light_gray)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Recognizing a Crisis", isExpanded: $isSectionOneExpanded) {
                                        Text("A crisis might look like someone talking about self-harm, showing extreme emotional distress, or losing touch with reality. It's more than just a bad day.")
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
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Immediate Actions", isExpanded: $isSectionTwoExpanded) {
                                        Text("If someone's in immediate danger, don't wait. Call emergency services. If it's not life-threatening but still serious, guide them to urgent but non-emergency care, like a crisis hotline or a walk-in clinic.")
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
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Stay Calm and Supportive", isExpanded: $isSectionTwoExpanded) {
                                        Text("If you're helping someone through a crisis, try to stay calm. Your calmness can be contagious. Let them know you're there for them and take their concerns seriously.")
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
                                .background(np_light_gray)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: Emergency Contact Information
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Emergency Contact Information", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.heavy)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_light_gray)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Hotlines and Text Lines", isExpanded: $isSectionThreeExpanded) {
                                        Text("Keep a list of mental health crisis hotlines and text services. These are great resources for immediate, anonymous support.")
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
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Local Emergency Services", isExpanded: $isSectionFourExpanded) {
                                        Text("Have the numbers for local emergency services handy. In many places, this will be 911, 999 etc, depending on where you live.")
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
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Mental Health Clinics", isExpanded: $isSectionFiveExpanded) {
                                        Text("Know where the nearest mental health clinic or hospital is. Sometimes, professional help is needed ASAP.")
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
                                .background(np_light_gray)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: Creating a Safety Plan
                            VStack {
                                HStack(spacing: 5) {
                                    Label("Creating a Safety Plan", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_light_gray)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("For Personal Use", isExpanded: $isSectionSixExpanded) {
                                        Text("If you often find yourself in a crisis, work with a therapist or counselor to create a safety plan. This plan includes signs that a crisis may be developing, coping strategies, and people to contact for help.")
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
                                    
                                    Divider()
                                    
                                    DisclosureGroup("For Helping Others", isExpanded: $isSectionSevenExpanded) {
                                        Text("If you're supporting someone, encourage them to develop a safety plan and be a part of it if appropriate. Know what their triggers are, what helps them calm down, and who they want to contact in a crisis.")
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
                                .background(np_light_gray)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 10)
                            }
                            
                            // MARK: After a Crisis
                            VStack {
                                HStack(spacing: 5) {
                                    Label("After a Crisis", systemImage: "")
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(np_light_gray)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 10) {
                                    DisclosureGroup("Post-Crisis Support", isExpanded: $isSectionEightExpanded) {
                                        Text("After a crisis, ongoing support is crucial. This might mean professional counseling, support groups, or just checking in regularly.")
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
                                    
                                    Divider()
                                    
                                    DisclosureGroup("Self-Care for Supporters", isExpanded: $isSectionNineExpanded) {
                                        Text("If you've helped someone through a crisis, take care of yourself too. It can be emotionally draining, so don't forget to recharge.")
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
                                .background(np_light_gray)
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
                    .background(Circle().fill(np_red))
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
                .fill(np_black)
                .opacity(0.98)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GettingRealView()
}
