//
//  TaskCategory.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-12.
//

import SwiftUI

// MARK: Category Codable Struct
struct CategoryCodable: Codable {
    var name: String
}

// MARK: Category Enum with Color
enum Category: String, CaseIterable, Codable {
    case blue
    case burgundy
    case green
    case turquiose
    case orange
    case purple
    case gray
    case pink
    case dark_blue
    case red
    
    var color: Color {
        switch self {
        case .blue:
            return np_blue
        case .burgundy:
            return np_burgundy
        case .green:
            return np_green
        case .turquiose:
            return np_turq
        case .orange:
            return np_orange
        case .purple:
            return np_purple
        case .gray:
            return np_gray
        case .pink:
            return np_pink
        case .dark_blue:
            return np_dark_blue
        case .red:
            return np_red
        }
    }
    
    // Helper method to convert between Category and CategoryCodable
    func toCodable() -> CategoryCodable {
        return CategoryCodable(name: self.rawValue)
    }
    
    static func fromCodable(_ codable: CategoryCodable) -> Category? {
        return Category(rawValue: codable.name)
    }
}


