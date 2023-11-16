//
//  QuoteView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-16.
//

import SwiftUI

struct AffirmationView: View {
    let affirmation : [Affirmation] = affirmData
    
    // MARK: 'Quote of the day' generation
    var dailyAffirmation: Affirmation {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date())
        let index = (dayOfYear! - 1) % affirmation.count
        return affirmation[index]
    }
    
    var body: some View {
        VStack {
            AffirmationCard(affirmation: dailyAffirmation.affirmation).padding(5)
        }
        .background(np_jap_indigo)
        .cornerRadius(10)
        .padding(.bottom, 20)
        .padding(.bottom, 5)
        .shadow(color: np_white, radius: 0.1, x: 5, y: 5)
    }
}

// MARK: Quote Card
struct AffirmationCard : View {
    var affirmation : String
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 15) {
            Image("right-quote")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(np_white,lineWidth: 2)
                        .padding(40)
                }
                .frame(width: 60, height: 60, alignment: .center)
                .padding(.bottom, 5)
                .foregroundColor(np_white)
            
            Text(#""\#(affirmation)""#)
                .font(.custom("Analogist", size: 20))
                .fontWeight(.semibold)
                .kerning(3)
                .textCase(.uppercase)
                .italic()
                .foregroundColor(np_white)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: screenWidth - 40, height: screenHeight * 0.3, alignment: .center)
    }
}

struct QuoteView_Previews : PreviewProvider {
    static var previews: some View {
        AffirmationView()
    }
}
