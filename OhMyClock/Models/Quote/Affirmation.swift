//
//  Quote.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-16.
//

import Foundation
import SwiftUI
import UIKit

struct Affirmation : Hashable, Decodable {
    let affirmation : String
}

let affirmData: [Affirmation] = load("affirmation.json")

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
