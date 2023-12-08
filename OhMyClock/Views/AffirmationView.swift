//
//  QuoteView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-16.
//

import SwiftUI

struct AffirmationView: View {
    let affirmation : [Affirmation] = affirmData
    let width = UIScreen.main.bounds.width
    
    // MARK: 'Quote of the day' generation
    var dailyAffirmation: Affirmation {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date())
        let index = (dayOfYear! - 1) % affirmation.count
        return affirmation[index]
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1.5)
                .foregroundColor(np_white)
                .frame(width: width - 40)
                .overlay {
                    AffirmationCard(affirmation: dailyAffirmation.affirmation).padding(5)
                }
        }
        .padding(10)
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Quote Card
struct AffirmationCard : View {
    var affirmation : String
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 5) {
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
                .foregroundColor(np_white)
            
            Text(#""\#(affirmation)""#)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .kerning(3)
                .textCase(.uppercase)
                .foregroundColor(np_white)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.65)
                .padding()
        }
        .frame(maxWidth: width - 40, maxHeight: height * 0.5, alignment: .center)
    }
}

struct QuoteView_Previews : PreviewProvider {
    static var previews: some View {
        AffirmationView()
    }
}
