//
//  Persist.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import Foundation
import CoreData


class Persist {
    
    let player = Player()
    var path: URL!
    
    /// Save audio into device storage and Core Data
    /// - Parameter key: Name of file. If it's nil, replaces with current date
    func saveAudio(for key: String?) {
        // Code for saving audio recordings.
        // Need to save by current data and custom
        // names, also need IDs and URL to file.
        
        let name: String
        
        if key != nil {
            name = key!
        } else {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyy-M-d-HH:mm"
            name = dateFormatter.string(from: date as Date)
        }
        
        rename("newRecording", name)
        
        guard let path = filePath(for: name) else {
            print("Error")
            return
        }
        
        self.path = path
        
        print(path)
    }
    
    
    func play() {
        if path != nil {
            player.play(path)
        }
    }
    
    /// Finds audio from documents directory and returns file for play
    func getAudio(for key: String) {
        // Code for getting audio. Need to
        // find files by URL from Core Data.
    }
    
    /// Finds all audio in Core Data and returns array with data about them
    func fetch() {
        
    }
    
    func rename(_ initialName: String, _ resultName: String) {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return }

        guard let path = filePath(for: initialName) else { return }
        guard let resultPath = filePath(for: resultName) else { return }

        do {
            try fileManager.moveItem(at: path, to: resultPath)
        } catch {
            print("[FAIL] File don't renamed: ")
            print(error)
        }
        
//        guard var path = filePath(for: initialName) else { return }
//        path.setTemporaryResourceValue("\(resultName).m4a", forKey: .nameKey)
//
//        if var path = filePath(for: initialName) {
//            path.setTemporaryResourceValue("\(resultName).m4a", forKey: .nameKey)
//        }
    }
    
    /// Finding file path for audio
    private func filePath(for key: String) -> URL? {
        let fileManager = FileManager.default
        
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".m4a")
    }
    
}

