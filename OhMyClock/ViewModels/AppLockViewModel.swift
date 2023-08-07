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
                                self.disableAppLock()
                                // If the user is not signed in and FaceID is turned off, you might want to navigate to the login view
                                if !self.isUserSignedIn {
                                    // Navigate to the login view
                                    // Note: You'll need to implement the actual logic to navigate to the login view
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
                
                // MARK: Show Alert on toggle
                laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                if appLockState {
                                    self.enableAppLock()
                                    self.isAppUnlocked = true
                                    self.needsUnlock = false
                                    // Notify the view to show a success alert for enabling
                                    // You could use a Combine Publisher or delegate pattern here
                                } else {
                                    self.disableAppLock()
                                    self.isAppUnlocked = true
                                    self.needsUnlock = false
                                    // Notify the view to show a success alert for disabling
                                    // You could use a Combine Publisher or delegate pattern here
                                }
                            }
                        } else {
                            // Notify the view to show an error alert
                            // You could use a Combine Publisher or delegate pattern here
                            if let error = error {
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
