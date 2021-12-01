//
//  SettingsCell.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 12/1/21.
//

import UIKit


class SettingsCell: UITableViewCell {
    
    private var icon: ImageView?
    private var label: Label?
    public var _switch: UISwitch?
    
    @objc private func toogleAutoRecord(_ sender: UISwitch) {
        if sender.isOn {
            Constants().isRecordingAtLaunchEnabled = true
            print("on")
        } else {
            Constants().isRecordingAtLaunchEnabled = false
            print("off")
        }
    }
    
    init(reuseIdentifier: String, icon: ImageView, label: Label, isUsingSwitch: Bool) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor(named: "BackgroundColorTabBar")
        selectedBackgroundView = selectedBackground
        
        self.icon = icon
        self.label = label
        
        self.label?.textColor = .white
        
        addSubview(self.icon!)
        addSubview(self.label!)
        
        self.icon!.translatesAutoresizingMaskIntoConstraints = false
        self.label!.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [
            self.icon!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            self.icon!.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.icon!.widthAnchor.constraint(equalToConstant: 20),
            self.icon!.heightAnchor.constraint(equalToConstant: 20),
            
            self.label!.leadingAnchor.constraint(equalTo: self.icon!.trailingAnchor, constant: 20),
            self.label!.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        if isUsingSwitch {
            _switch = UISwitch()
            _switch!.tag = 0
            _switch!.addTarget(self, action: #selector(toogleAutoRecord(_:)), for: .valueChanged)
            
            accessoryView = _switch
            
            if Constants().isRecordingAtLaunchEnabled {
                _switch!.setOn(true, animated: true)
            } else {
                _switch!.setOn(false, animated: true)
            }
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
