//
//  TaskCategory.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-12.
//

import SwiftUI

// MARK: Cateogry Enum with Color
enum Category: String, CaseIterable {
    case wellness = "Wellness"
    case work = "Work"
    case personal = "Personal"
    case exercise = "Exercise"
    case retail = "Retail"
    
    var color: Color {
        switch self {
        case .wellness:
            return np_blue
        case .work:
            return np_orange
        case .personal:
            return np_turq
        case .exercise:
            return np_green
        case .retail:
            return np_purple
        }
    }
}
