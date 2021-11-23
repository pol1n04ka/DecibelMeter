//
//  Label.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/20/21.
//

import UIKit


class Label: UILabel {
    
    enum LabelStyle {
        case heading
        case body
        case separator
        case decibelHeading
        case timeTitle
        case time
        case avgMinMax
    }
    
    init(style: LabelStyle, _ text: String?) {
        super.init(frame: .zero)
        
        self.text = text
        textColor = .white
        numberOfLines = 0
        textAlignment = .center
        
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .heading:
            font = UIFont(name: "OpenSans-Bold", size: 18)
        case .body:
            font = UIFont(name: "OpenSans-Regular", size: 15)
        case .separator:
            font = UIFont(name: "OpenSans-Regular", size: 12)
            self.text = "|"
        case .decibelHeading:
            font = UIFont(name: "OpenSans-Bold", size: 50)
        case .timeTitle:
            font = UIFont(name: "OpenSans-SemiBold", size: 10)
        case .time:
            font = UIFont(name: "OpenSans-Bold", size: 20)
        case .avgMinMax:
            font = UIFont(name: "OpenSans-Bold", size: 15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
