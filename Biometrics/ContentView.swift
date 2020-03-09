//
//  ContentView.swift
//  Biometrics
//
//  Created by zgpeace on 2020/1/9.
//  Copyright © 2020 zgpeace. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    var body: some View {
//        Text("Hello, World!").onAppear {
//            self.validateBiometrics()
//        }
        Button(action: {
            self.validateBiometrics()
        }) {
            Text("Authorize Biometric")
        }
    }
    
    func authorizeBiometrics(_ context: LAContext) {
        // Device can use biometric authentication
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access requires authentication") { (success, error) in
            if let err = error {
                switch err._code {
                case LAError.Code.systemCancel.rawValue:
                    self.notifyUser("Session cancelled", err: err.localizedDescription)
                case LAError.Code.userCancel.rawValue:
                    self.notifyUser("Please try again", err: err.localizedDescription)
                case LAError.Code.userFallback.rawValue:
                    self.notifyUser("Authentication", err: "Password option selected")
                // Custom Code to obtain password here
                default:
                    self.notifyUser("Authentication failed", err: error?.localizedDescription)
                }
            } else {
                //                    self.notifyUser("Authentication Successful", err: "You now have full access")
                if (context.biometryType == LABiometryType.faceID) {
                    // Device support Face ID
                    self.notifyUser("Authentication Successful", err: "Device support Face ID")
                } else if context.biometryType == LABiometryType.touchID {
                    // Device supports Touch ID
                    self.notifyUser("Authentication Successful", err: "Device supports Touch ID")
                } else {
                    // Device has no biometric support
                    self.notifyUser("Authentication Successful", err: "Device has no biometric support")
                }
            }
        }
    }
    
    func validateBiometrics() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            print("Biometry is available on the device")
            authorizeBiometrics(context)
        } else {
            print("Biometry is not available on the device")
            print("No hardware support to user has not set up biometric auth")
            
            // Device cannot use biometric authentication
            if let err = error {
                switch err.code {
                case LAError.Code.biometryNotEnrolled.rawValue:
                    notifyUser("User is not enrolled", err: err.localizedDescription)
                    
                case LAError.Code.passcodeNotSet.rawValue:
                    notifyUser("A passcode has not been set", err: err.localizedDescription)
                    
                case LAError.Code.biometryNotAvailable.rawValue:
                    notifyUser("Biometric authentication not available", err: err.localizedDescription)
                default:
                    notifyUser("Unknown error", err: err.localizedDescription)
                }
            }
        }
    }
    
    func notifyUser(_ msg: String, err: String?)  {
        print("msg > \(msg)")
        print("err > \(err)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

