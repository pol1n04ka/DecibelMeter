//
//  Record.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

/*

 1. 
 
*/

import UIKit


class RecordView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension RecordView {
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        
    }
    
}
