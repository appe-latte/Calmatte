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
    case red, blue, green, indigo, purple, tan, pink, tuscan, turquiose, orange
    
    var color: Color {
        switch self {
        case .red:
            return np_red
        case .blue:
            return np_blue
        case .green:
            return np_green
        case .indigo:
            return np_jap_indigo
        case .purple:
            return np_purple
        case .tan:
            return np_tan
        case .pink:
            return np_pink
        case .tuscan:
            return np_tuscan
        case .turquiose:
            return np_turq
        case .orange:
            return np_orange
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


