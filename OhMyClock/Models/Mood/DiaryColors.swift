//
//  DiaryColors.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-11.
//

import Foundation
import SwiftUI

class DiaryColors: ObservableObject {
    // MARK: Foreground
    @Published var textColor: Color = np_black
    @Published var todayColor: Color = np_red
    @Published var disabledColor: Color = np_gray
    @Published var selectedColor: Color = np_munsell_blue

    // MARK: Background
    @Published var backgroundColor: Color = Color.clear
    @Published var weekdayBackgroundColor: Color = Color.clear
    @Published var selectedBackgroundColor: Color = np_tan

}
