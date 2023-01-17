//
//  LocationManager.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-01-15.
//

import Combine
import Foundation

class LocationManager: NSObject, ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var someVar: Int = 0 {
        willSet { objectWillChange.send() }
    }
    
    override init(){
        super.init()
    }
}
