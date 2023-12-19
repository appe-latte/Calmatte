//
//  RiseShineCardView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-12-07.
//

import SwiftUI

struct RiseShineCardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var trackTime : Int = 2
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    Image("img-sunrise")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width - 20, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // MARK: Title
                    HStack {
                        Text("Rise n' Shine")
                            .font(.system(size: 23, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .kerning(1)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: Track Time
                    HStack {
                        Text("Wellness Activity •")
                            .font(.system(size: 8, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .kerning(1)
                            .foregroundColor(np_white)
                        
                        Text("\(trackTime)min")
                            .font(.system(size: 8, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .kerning(1)
                            .foregroundColor(np_white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button {
                        //
                    } label: {
                        HStack {
                            Image("lock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            Text("Subscribe to Calmatte Plus")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .kerning(1)
                                .textCase(.uppercase)
                        }
                    }
                    .frame(width: width * 0.6, height: 40)
                    .foregroundColor(np_jap_indigo)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(np_white)
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
                .fill(np_arsenic)
                .frame(height: size.height, alignment: .bottom)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RiseShineCardView()
}
