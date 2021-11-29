//
//  Recorder.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/20/21.
//

import Foundation
import AVFoundation
import UIKit


public protocol RecorderDelegate: NSObject, AVAudioRecorderDelegate {
    func recorderDidFailToAchievePermission(_ recorder: Recorder)
    func recorder(_ recorder: Recorder, didCaptureDecibels decibels: Int)
}


public class Recorder {
    
    // MARK: Values for show sound information
    private var isMonitoring = false
    private var timer: Timer!
    public var decibels: [Int] = Array(repeating: 0, count: 60)
    public var avg: Int? {
        if decibels.count != 0 {
            return decibels.reduce(0) { $0 + $1 } / decibels.count
        }
        
        return 0
    }
    
    public var min: Int? {
        return decibels.min()
    }
    
    public var max: Int? {
        return decibels.max()
    }
    
    // MARK: Main variables for this class
    var session:  AVAudioSession!
    var recorder: AVAudioRecorder!
    var delegate: RecorderDelegate?
    var avDelegate: AVAudioRecorderDelegate?
    
}

// MARK: Start
extension Recorder {
    
    /// Start record
    public func record(_ delegate: AVAudioRecorderDelegate) {
        session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            // failed to start recording
            print(error)
        }
        
        // code for setting up it
        checkPermissionAndStartRecording()
    }
    
    private func startRecording() {
        let audioFilename = getDocumentDirectory().appendingPathComponent("newRecording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recorder.delegate = self.avDelegate
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
            recorder.record()
        } catch {
            print(error)
        }
    }
    
    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func checkPermissionAndStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            startRecording()
        case .undetermined:
            requestPermissions()
        case .denied:
            delegate?.recorderDidFailToAchievePermission(self)
        @unknown default:
            requestPermissions()
        }
    }
    
    private func requestPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                self.startRecording()
            } else {
                self.checkPermissionAndStartRecording()
            }
        }
    }
    
}


// MARK: Stop
extension Recorder {
    
    /// Stop recorder
    public func stop() {
        // Code for make session nil and prepare for
        // next recording or play it
    }
    
}


// MARK: Decibels logic
extension Recorder {
    
    /// Get average power in dBFS
    private func getDecibels() -> Float {
        recorder.updateMeters()
        return 96 - abs(recorder.averagePower(forChannel: 0))
    }
    
    /// Starts printing dBFS
    public func startMonitoring() {
        if recorder != nil {
            isMonitoring = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if !self.isMonitoring {
                    timer.invalidate()
                } else {
                    self.delegate?.recorder(self, didCaptureDecibels: Int(self.getDecibels()))
                    if self.decibels.count <= 60 {
                        self.decibels.append(Int(self.getDecibels()))
                    } else {
                        self.decibels.remove(at: 0)
                        self.decibels.append(Int(self.getDecibels()))
                    }
                }
            }
        }
    }
    
    public func stopMonitoring() {
        isMonitoring = false
        
        if isMonitoring == false, timer != nil {
            timer.invalidate()
        }
    }
    
}



//public protocol SoundRecorderDelegate: AnyObject {
//    func audioInputManagerDidFailToAchievePermission(_ soundRecorder: SoundRecorder)
//    func audioInputManager(_ soundRecorder: SoundRecorder, didCaptureChannelData channelData: [Int16])
//    func printDecibels(_ soundRecorder: SoundRecorder, didCaptureChanelData channelData: Float)
//}
//
//
///// Class for get sound stream from microphone
//public class SoundRecorder {
//    
//    // MARK: Constants
//    public let bufferSize: Int
//    private let sampleRate: Int
//    private let conversionQueue = DispatchQueue(label: "conversionQueue")
//    
//    // MARK: Variables
//    public weak var delegate: SoundRecorderDelegate?
//    public let audioEngine = AVAudioEngine()
//    
//    // MARK: Methods
//    public init(sampleRate: Int) {
//        self.sampleRate = sampleRate
//        self.bufferSize = sampleRate * 2
//    }
//    
//    public func checkPermissionAndStartTappingMicrophone() {
//        switch AVAudioSession.sharedInstance().recordPermission {
//        case .granted:
////            startTappingMicrophone()
//            startRecord()
//        case .undetermined:
//            requestPermissions()
//        case .denied:
//            delegate?.audioInputManagerDidFailToAchievePermission(self)
//        @unknown default:
//            requestPermissions()
//        }
//    }
//
//    public func requestPermissions() {
//        AVAudioSession.sharedInstance().requestRecordPermission { granted in
//            if granted {
//                self.startTappingMicrophone()
//            } else {
//                self.checkPermissionAndStartTappingMicrophone()
//            }
//        }
//    }
//    
//    /// Changes category of audio session for record or play sound
//    ///  ```
//    ///  true // record mode
//    ///  false // play mode
//    public func setListenOrPlayMode(_ modeToSet: Bool) {
//        let mode: AVAudioSession.Category
//        let options: AVAudioSession.CategoryOptions
//    
//        switch modeToSet {
//        case true:
//            mode = .playAndRecord
//            options = [.mixWithOthers]
////            print("Setting category to record")
//        case false:
//            mode = .playAndRecord
//            options = [.defaultToSpeaker]
////            print("Setting category to playback")
//        }
//        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(mode, options: options)
//            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    public func startRecord() {
//        let format = audioEngine.mainMixerNode.outputFormat(forBus: 0)
//        
//        audioEngine.mainMixerNode.installTap(
//            onBus: 0,
//            bufferSize: 1024,
//            format: format
//        ) { buffer, _ in
//            guard let channelData = buffer.floatChannelData else {
//                return
//            }
//          
//            let channelDataValue = channelData.pointee
//            let channelDataValueArray = stride(
//            from: 0,
//            to: Int(buffer.frameLength),
//            by: buffer.stride).map { channelDataValue[$0] }
//          
//            let rms = sqrt(channelDataValueArray.map {
//                return $0 * $0
//            }
//            .reduce(0, +) / Float(buffer.frameLength))
//          
//            let avgPower = 20 * log10(rms)
//            
////            self.delegate?.printDecibels(self, didCaptureChanelData: avgPower)
//            
//            print(channelData)
//            
//            
//            
//        }
//        
//        audioEngine.prepare()
//        do {
//            try audioEngine.start()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    public func startTappingMicrophone() {
//        let inputNode = audioEngine.inputNode
//        let inputFormat = inputNode.outputFormat(forBus: 0)
//        
//        guard let recordingFormat = AVAudioFormat(
//            commonFormat: .pcmFormatInt16,
//            sampleRate: Double(sampleRate),
//            channels: 1,
//            interleaved: true
//        ), let formatConverter = AVAudioConverter(
//            from: inputFormat,
//            to: recordingFormat
//        ) else { return }
//        
//        inputNode.installTap(onBus: 0,
//                             bufferSize: AVAudioFrameCount(bufferSize),
//                             format: inputFormat) { buffer, _ in
//            self.conversionQueue.async {
//                guard let pcmBuffer = AVAudioPCMBuffer(
//                    pcmFormat: recordingFormat,
//                    frameCapacity: AVAudioFrameCount(recordingFormat.sampleRate * 2.0)
//                ) else { return }
//                
//                var error: NSError?
//                let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
//                    outStatus.pointee = AVAudioConverterInputStatus.haveData
//                    return buffer
//                }
//                
//                formatConverter.convert(to: pcmBuffer, error: &error, withInputFrom: inputBlock)
//                
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                
//                if let channelData = pcmBuffer.int16ChannelData {
//                    let channelDataValue = channelData.pointee
//                    let channelDataValueArray = stride(
//                        from: 0,
//                        through: Int(pcmBuffer.frameLength),
//                        by: buffer.stride
//                    ).map { channelDataValue[$0] }
//                    
//                    self.delegate?.audioInputManager(self, didCaptureChannelData: channelDataValueArray)
//                }
//            }
//        }
//        
//        audioEngine.prepare()
//        do {
//            try audioEngine.start()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//}
