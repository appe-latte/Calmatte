//
//  QuoteView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-16.
//

import SwiftUI

struct QuoteView: View {
    let quotes : [Quote] = quoteData
    
    // MARK: 'Quote of the day' generation
    var quoteOfTheDay: Quote {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date())
        let index = (dayOfYear! - 1) % quotes.count
        return quotes[index]
    }
    
    var body: some View {
        VStack {
            QuoteCard(quote: quoteOfTheDay.quote, author: quoteOfTheDay.name).padding(5)
        }
        .background(np_jap_indigo)
        .cornerRadius(10)
        .padding(.bottom, 20)
        .padding(.bottom, 5)
        .shadow(color: np_white, radius: 0.1, x: 5, y: 5)
    }
}

// MARK: Quote Card
struct QuoteCard : View {
    var quote : String
    var author : String
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 15) {
            Image("right-quote")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(np_white,lineWidth: 2)
                        .padding(40)
                }
                .frame(width: 75, height: 75, alignment: .center)
                .padding(.bottom, 5)
                .foregroundColor(np_white)
            
            Text(#""\#(quote)""#)
                .font(.footnote)
                .fontWeight(.semibold)
                .kerning(3)
                .textCase(.uppercase)
                .italic()
                .foregroundColor(np_white)
                .multilineTextAlignment(.center)
                .padding()
            
            Divider()
            
            Text("\(author)")
                .font(.system(size: 10))
                .fontWeight(.bold)
                .kerning(5)
                .textCase(.uppercase)
                .foregroundColor(np_white)
                .padding(.top, 15)
        }
        .frame(width: screenWidth - 40, height: screenHeight * 0.35)
    }
}

struct QuoteView_Previews : PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
