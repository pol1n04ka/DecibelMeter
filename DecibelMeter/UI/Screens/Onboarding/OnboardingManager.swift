//
//  OnboardingManager.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/20/21.
//

import Foundation

class OnboardingManager {
    
    static let shared = OnboardingManager()
    
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
}
