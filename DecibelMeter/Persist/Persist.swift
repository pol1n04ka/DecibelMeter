//
//  Persist.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import Foundation
import CoreData
import UIKit


public class Persist {
    
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: Temporary
    let player = Player()
    var path: URL!
    var id: UUID!
    
    /// Save audio into device storage and Core Data
    /// - Parameter key: Name of file. If it's nil, replaces with current date
    func saveAudio(info: RecordInfo) {
        let context = container.newBackgroundContext()

        rename("newRecording", info.id.uuidString)
        
        guard let path = filePath(for: info.id.uuidString) else {
            print("Error")
            return
        }
        
        self.path = path
        
        print(path)
        
        let newRecording = Record(context: context)
        newRecording.id     = info.id
        newRecording.name   = info.name
        newRecording.length = info.length
        newRecording.date   = info.date
        newRecording.avg    = Int16(info.avg)
        newRecording.min    = Int16(info.min)
        newRecording.max    = Int16(info.max)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    func play() {
        if path != nil {
            player.play(path)
        }
    }
    
    /// Finds audio from documents directory and returns file for play
    public func getAudio(for key: String) {
        // Code for getting audio. Need to
        // find files by URL from Core Data.
    }
    
    /// Finds all audio in Core Data and returns array with data about them
    public func fetch() -> [Record]? {
        do {
            let response = try viewContext.fetch(Record.fetchRequest())
            return response
        } catch {
            print(error)
        }
        
        return nil 
    }
    
    /// Rename recently saved audio
    private func rename(_ initialName: String, _ resultName: String) {
        let fileManager = FileManager.default
        guard let path = filePath(for: initialName) else { return }
        guard let resultPath = filePath(for: resultName) else { return }

        do {
            try fileManager.moveItem(at: path, to: resultPath)
        } catch {
            print("[FAIL] File don't renamed: ")
            print(error)
        }
    }
    
    /// Finding file path for audio
    public func filePath(for key: String) -> URL? {
        let fileManager = FileManager.default
        
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".m4a")
    }
    
}

