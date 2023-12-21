//
//  HealingWatersView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-21.
//

import SwiftUI

struct WaterCardView: View {
    var trackTime : Int = 2
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    Image("img-water")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: 400, alignment: .topLeading)
                        .overlay {
                            VStack(spacing: 5) {
                                Spacer()
                                
                                // MARK: Title
                                HStack {
                                    Text("Water's Healing Powers")
                                        .font(.system(size: 23, design: .rounded))
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                        .kerning(3)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                // MARK: Track Time
                                HStack(spacing: 5) {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 9))
                                        .fontWeight(.heavy)
                                        .foregroundStyle(np_white)
                                    
                                    Text("Wellness Activity •")
                                        .font(.system(size: 8, design: .rounded))
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                        .kerning(2)
                                        .foregroundColor(np_white)
                                    
                                    Text("\(trackTime)min")
                                        .font(.system(size: 8, design: .rounded))
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                        .kerning(2)
                                        .foregroundColor(np_white)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.vertical, 10)
                        }
                        .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
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
                .fill(np_arsenic)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WaterCardView()
}
