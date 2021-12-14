//
//  Saved.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit
import AVFAudio


class SavedView: UIViewController {
    
    let persist = Persist()
    var recordings: [Record]?
    var player: Player!
    var isPlaying: Bool = false
    var tagPlaying: Int?
    var tags: [Int] = []
    
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
        
        buttonToogler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let result = persist.fetch() else { return }
        recordings = result
        
        tableView.reloadData()
        
        buttonToogler()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // FIXME: NEED REFACTORING
    func buttonToogler() {
        for tag in tags {
            let tmp = self.tableView.cellForRow(at: [0, tag]) as! SavedCell
            
            if tmp.isPlaying {
                if let tagPlaying = tagPlaying {
                    if tmp.tag == 0 {
                        if tmp.isPlaying {
                            print("wrong")
                            tmp.isPlaying = false
                            tmp.playButton.setImage(UIImage(named: "Play"), for: .normal)
                            if player.player.isPlaying {
                                player.player.stop()
                            }
                        } else {
                            print("true")
                            tmp.isPlaying = true
                            tmp.playButton.setImage(UIImage(named: "Pause"), for: .normal)
                        }
                    } else if tmp.tag == tagPlaying {
                        print("true")
                        tmp.isPlaying = true
                        tmp.playButton.setImage(UIImage(named: "Pause"), for: .normal)
                    } else {
                        print("wrong")
                        tmp.isPlaying = false
                        tmp.playButton.setImage(UIImage(named: "Play"), for: .normal)
                        if player.player.isPlaying {
                            player.player.stop()
                        }
                    }
                }
            }
        }
    }
    
    @objc func playOrPauseAudio(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: [0, sender.tag]) as? SavedCell
        
        if sender.tag == 0 {
//            cell?.isPlaying = false
            tagPlaying = 0
        }
        
        buttonToogler()
        
        if isPlaying == false {
            let button = sender as! Button
            guard let path = Persist().filePath(for: button.uuid!.uuidString) else { return }
            isPlaying = true
            cell?.isPlaying = true
            sender.setImage(UIImage(named: "Pause"), for: .normal)
            self.tagPlaying = sender.tag
            player = Player()
            player.play(path, delegate: self)
        } else {
            isPlaying = false
            cell?.isPlaying = true
            sender.setImage(UIImage(named: "Play"), for: .normal) 
            player.player.stop()
            player.session = nil
            self.tagPlaying = nil
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
            self.tags = Array(0..<recordings!.count)
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
                min: "MIN " + String(recording.min),
                max: "MAX " + String(recording.max),
                avg: "AVG " + String(recording.avg)
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
        guard let path = persist.filePath(for: recording.id!.uuidString) else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [path],
            applicationActivities: nil
        )
        
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


extension SavedView: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Good")
            buttonToogler()
        } else {
            print("Not good")
        }
    }
    
}
