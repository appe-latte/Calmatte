//
//  AppLockViewModel.swift
//  OhMyClock
//
//  Created by Stanford L. Khumalo on 2023-07-18.
//

import SwiftUI
import FirebaseAuth
import LocalAuthentication

class AppLockViewModel: ObservableObject {
    @Published var isAppLockEnabled : Bool = false
    @Published var isAppUnlocked : Bool = false
    @Published var needsUnlock : Bool = false
    
    // MARK: Check for signed in user
    var isUserSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    init() {
        getAppLockState()
    }
    
    func checkIfBioMetricAvailable() -> Bool {
        var error : NSError?
        let laContext = LAContext()
        let isBiometricAvailable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            print(error.localizedDescription)
        }
        return isBiometricAvailable
    }
    
    // MARK: enable AppLock
    func enableAppLock() {
        UserDefaults.standard.set(true,forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = true
    }
    
    // MARK: disable AppLock
    func disableAppLock() {
        UserDefaults.standard.set(false,forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = false
    }
    
    // MARK: check AppLock state
    func getAppLockState() {
        isAppLockEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        if isAppLockEnabled && !checkIfBioMetricAvailable() {
            disableAppLock()
        }
    }
    
    func appLockStateChange(appLockState: Bool) {
        let isUserSignedIn = Auth.auth().currentUser
        
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
                    DispatchQueue.main.async {
                        if appLockState {
                            self.enableAppLock()
                        } else {
                            self.disableAppLock() // If the user is not signed in and FaceID is turned off, you might want to navigate to the login view
                            if !self.isUserSignedIn {
                                //
                            }
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
            
            // MARK: "Alert" toggle
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        if appLockState {
                            self.enableAppLock()
                            self.isAppUnlocked = true
                            self.needsUnlock = false
                        } else {
                            self.disableAppLock()
                            self.isAppUnlocked = true
                            self.needsUnlock = false
                        }
                    }
                } else {
                    if let error = error { // Notify the view to show an error alert
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
                        self.needsUnlock = false
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
