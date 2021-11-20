//
//  Saved.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit


class SavedView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension SavedView {
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
}
