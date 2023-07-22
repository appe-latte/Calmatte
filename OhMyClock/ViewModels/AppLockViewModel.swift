//
//  AppLockViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import SwiftUI
import LocalAuthentication

class AppLockViewModel: ObservableObject {
    @Published var isAppLockEnabled : Bool = false
    @Published var isAppUnlocked : Bool = false
    @Published var needsUnlock : Bool = false  // added this line
    
    init() {
        getAppLockState()
    }
    
    // your other functions...
    func checkIfBioMetricAvailable() -> Bool {
        var error : NSError?
        let laContext = LAContext()
        let isBiometricAvailable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            print(error.localizedDescription)
        }
        return isBiometricAvailable
    }
    
    func enableAppLock() {
        UserDefaults.standard.set(true,forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = true
    }
    
    func disableAppLock() {
        UserDefaults.standard.set(false,forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = false
    }
    
    func getAppLockState() {
        isAppLockEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        // Check if biometric authentication is still available when app lock is enabled
        if isAppLockEnabled && !checkIfBioMetricAvailable() {
            disableAppLock()
        }
    }
    
    func appLockStateChange(appLockState:Bool) {
        let laContext = LAContext()
        if checkIfBioMetricAvailable(){
            var reason = ""
            if appLockState {
                reason = "To enable this biometric security feature for added safety."
            }
            else {
                reason = "To disable this biometric security feature."
            }
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ (success,error) in
                if success {
                    if appLockState {
                        DispatchQueue.main.async {
                            self.enableAppLock()
                            self.isAppUnlocked = true
                            self.needsUnlock = false  // added this line
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.disableAppLock()
                            self.isAppUnlocked = true
                            self.needsUnlock = false  // added this line
                        }
                    }
                } else {
                    if let error = error{
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func appLockValidation(){
        let laContext = LAContext()
        if checkIfBioMetricAvailable(){
            let reason = "Unlock to use the app."
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){(success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.isAppUnlocked = true
                        self.needsUnlock = false  // added this line
                    }
                } else {
                    if let error = error {
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

enum UserDefaultsKeys:String {
    case isAppLockEnabled
}
