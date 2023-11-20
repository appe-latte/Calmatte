//
//  Day.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import Foundation
import SwiftUI

class Day: ObservableObject {
    @Published var isSelected = false
    
    var selectableDays: Bool
    var dayDate: Date
    var dayName: String {
        dayDate.dateToString(format: "d")
    }
    
    var isToday = false
    var disabled = false
    let colors = DiaryColors()
    
    var textColor: Color {
        if isSelected {
            return colors.selectedColor
        } else if isToday {
            return np_red
        } else if disabled {
            return np_gray
        }
        return np_gray.opacity(0.15)
    }
    
    var backgroundColor: Color {
        if isSelected {
            return colors.selectedBackgroundColor
        } else {
            return colors.backgroundColor
        }
    }
    
    var monthString: String {
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "LLL"
        
        let month = dateFormatter1.string(from: dayDate)
        
        return month
    }
    
    var dayAsInt: Int {
        let day = Calendar.current.component(.day, from: dayDate)
        return day
    }
    
    var year: String {
        return Calendar.current.component(.year, from: dayDate).description
    }
    
    init(date: Date, today: Bool = false, disable: Bool = false, selectable: Bool = true) {
        dayDate = date
        isToday = today
        disabled = disable
        selectableDays = selectable
    }
}

