//
//  TimerModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-03-07.
//

import SwiftUI
import Foundation

class TimerModel : NSObject, ObservableObject {
    @Published var progress : CGFloat = 1
    @Published var timerValue : String = "00:00"
    @Published var isStarted : Bool = false
    @Published var addNewTimer : Bool = false
    
    @Published var hour : Int = 0
    @Published var minutes : Int = 0
    @Published var seconds : Int = 0
}
