//
//  Constants.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/22/21.
//

import UIKit


public class Constants {
    
    public static let shared = Constants()
    
    public var isBig: Bool {
        if screenSize.height > 667 {
            return true
        } else {
            return false
        }
    }
    
    public var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
}
