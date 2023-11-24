//
//  UserViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-11-24.
//

import SwiftUI
import RevenueCat
import Foundation

class UserViewModel: ObservableObject {
    @Published var isSubscriptionActive = false
    
    init(){
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.isSubscriptionActive = customerInfo?.entitlements.all["calm_plus"]?.isActive == true
        }
    }
}
