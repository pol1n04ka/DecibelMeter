//
//  Saved.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit


class SavedView: UIViewController {
    
    let persist = Persist()
    
    lazy var titleLabel = Label(style: .titleLabel, "Saved")
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        tableView.delaysContentTouches = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension SavedView {
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}


extension SavedView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SavedCell(style: .default, reuseIdentifier: "cell")
        cell.playButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = UIContextualAction(style: .normal, title: "Save") { [weak self] (action, view, completionHandler) in
            self?.save()
            completionHandler(true)
        }
        save.backgroundColor = UIColor(named: "TableActionBlue")
        save.image = UIImage(named: "Save")
        
        let share = UIContextualAction(style: .normal, title: "Share") { [weak self] (action, view, completionHandler) in
            self?.share()
            completionHandler(true)
        }
        share.backgroundColor = UIColor(named: "TableActionGray")
        share.image = UIImage(named: "Share")
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.delete()
            completionHandler(true)
        }
        delete.backgroundColor = UIColor(named: "TableActionRed")
        delete.image = UIImage(named: "Delete")
        
        return UISwipeActionsConfiguration(actions: [delete, share, save])
    }
    
}


// MARK: Actions for table view
extension SavedView {
    
    func save() {
        print("Saved")
    }
    
    func share() {
        print("Shared")
    }
    
    func delete() {
        print("Deleted")
    }
}
