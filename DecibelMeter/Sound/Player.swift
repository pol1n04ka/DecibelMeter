//
//  Player.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/28/21.
//

import Foundation
import AVFAudio
import UIKit


class Player: NSObject {
    
    var session: AVAudioSession!
    var player: AVAudioPlayer!
    
    func play(_ filename: URL, delegate: AVAudioPlayerDelegate) {
        session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.ambient, mode: .default)
            try session.setActive(true)
        } catch {
            print(error)
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: filename)
            player.prepareToPlay()
            player.volume = 1.0
//            player.delegate = self
            player.delegate = delegate
            player.play()
            print("play")
        } catch {
            print(error)
        }
    }
    
}


//extension Player: AVAudioPlayerDelegate {
//    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        print("Good!")
//    }
//    
//}
