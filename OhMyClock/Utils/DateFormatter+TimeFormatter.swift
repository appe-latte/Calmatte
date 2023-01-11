//
//  DateFormatter+TimeFormatter.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-05.
//

import Foundation

extension DateFormatter {

    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmmss"
        return formatter
    }
}
