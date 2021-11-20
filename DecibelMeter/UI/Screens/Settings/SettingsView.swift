//
//  Settings.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit


class SettingsView: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Settings"
        l.textColor = .white
        l.textAlignment = .center
        l.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        
        return l
    }()
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        
        t.backgroundColor = .clear
        t.separatorColor = UIColor(named: "SeparatorColor")
        
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension SettingsView {
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}


extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = "hello"
        cell?.textLabel?.textColor = .white
        cell?.backgroundColor = .clear
        
        return cell!
    }
    
    
}


