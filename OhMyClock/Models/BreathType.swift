//
//  BreathType.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-06-28.
//

import Foundation
import SwiftUI

struct BreathType : Identifiable, Hashable {
    var id : String = UUID().uuidString
    var title : String
    var color : Color
}

let sampleTypes : [BreathType] = [
    .init(title: "Relax", color: np_tan),
    .init(title: "Anxious", color: np_green),
    .init(title: "Angry", color: np_purple)
]
