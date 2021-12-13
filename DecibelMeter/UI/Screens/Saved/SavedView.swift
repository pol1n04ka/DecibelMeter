//
//  Saved.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit


class SavedView: UIViewController {
    
    let persist = Persist()
    var recordings: [Record]?
    var player: Player!
    var isPlaying: Bool = false
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let result = persist.fetch() else { return }
        recordings = result
        print(recordings)
        
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func playOrPauseAudio(_ sender: UIButton) {
        if isPlaying == false {
            let button = sender as! Button
            guard let path = Persist().filePath(for: button.uuid!.uuidString) else { return }
            isPlaying = true
            sender.imageView?.image = UIImage(named: "Pause")
            player = Player()
            player.play(path)
        } else {
            isPlaying = false
            sender.imageView?.image = UIImage(named: "Play")
            player.player.stop()
            player.session = nil
        }
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
        if self.recordings != nil {
            return recordings!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SavedCell(style: .default, reuseIdentifier: "cell")
        
        if let recordings = self.recordings {
            let recording = recordings[indexPath.row]
                
            cell.setValues(
                name: recording.name ?? "",
                time: recording.length ?? "",
                min: String(recording.min),
                max: String(recording.max),
                avg: String(recording.avg)
            )
            
            cell.audioID = recording.id
            cell.playButton.uuid = recording.id
        }
        
        cell.playButton.addTarget(self, action: #selector(playOrPauseAudio(_:)), for: .touchUpInside)
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
        let share = UIContextualAction(style: .normal, title: "Share") { [weak self] (action, view, completionHandler) in
            self?.share(indexPath: indexPath)
            completionHandler(true)
        }
        share.backgroundColor = UIColor(named: "TableActionGray")
        share.image = UIImage(named: "Share")
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.delete(indexPath: indexPath)
            completionHandler(true)
        }
        delete.backgroundColor = UIColor(named: "TableActionRed")
        delete.image = UIImage(named: "Delete")
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
    
}


// MARK: Actions for table view
extension SavedView {
    
    func share(indexPath: IndexPath) {
        guard let recordings = recordings else { return }
        let recording = recordings[indexPath.row]
        let path = persist.filePath(for: recording.id!.uuidString)
        let activityVC = UIActivityViewController(activityItems: [path], applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
    }
    
    func delete(indexPath: IndexPath) {
        persist.viewContext.delete(recordings![indexPath.row])
        recordings!.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        do {
            try persist.viewContext.save()
        } catch {
            print(error)
        }
    }
}
