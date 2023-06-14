//
//  QuoteView.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-14.
//

import SwiftUI
import Foundation

struct QuoteView: View {
    @State private var quote: String = ""
    
    var body: some View {
        Text(quote)
            .onAppear {
                fetchQuote()
            }
    }
    
    func fetchQuote() {
        let headers = [
            "X-RapidAPI-Key": "56cc33b481msh2d7e39b70853e49p112fcajsn12a07af72b5c",
            "X-RapidAPI-Host": "quotes-inspirational-quotes-motivational-quotes.p.rapidapi.com"
        ]
        
        let url = URL(string: "https://quotes-inspirational-quotes-motivational-quotes.p.rapidapi.com/quote?token=ipworld.info")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                if let quoteData = try? JSONDecoder().decode(QuoteResponse.self, from: data),
                   let quote = quoteData.contents.quote {
                    DispatchQueue.main.async {
                        self.quote = quote
                    }
                }
            }
        }.resume()
    }
}

struct QuoteResponse: Codable {
    let contents: QuoteContents
}

struct QuoteContents: Codable {
    let quote: String?
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
