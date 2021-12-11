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
import KDCircularProgress
import SwiftCharts
import AVFAudio


class RecordView: UIViewController {
    
    private var isRecording = false
    
    // MARK: Audio recorder
    let recorder = Recorder()
    
    // MARK: UI elements
    lazy var decibelLabel   = Label(style: .decibelHeading, "0")
    lazy var timeLabel      = Label(style: .time, "00:00")
    lazy var timeTitleLabel = Label(style: .timeTitle, "TIME")
    
    lazy var progress = KDCircularProgress(
        frame: CGRect(x: 0, y: 0, width: view.frame.width / 1.2, height: view.frame.width / 1.2)
    )
    
    lazy var verticalStack = StackView(axis: .vertical)
    
    lazy var avgBar = AvgMinMaxBar()
    
    lazy var recordButton = Button(style: .record, nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recorder.delegate   = self
        recorder.avDelegate = self
        
        setupView()
        
        var minutes = (85 - (85 % 60)) / 60
        var seconds = 85 - (minutes * 60)
        
        print(minutes)
        print(seconds)
        
        if Constants().isRecordingAtLaunchEnabled {
            isRecording = true
            startRecordingAudio()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        recorder.stopMonitoring()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


// MARK: Record/stop button action
extension RecordView {
    
    @objc func startOrStopRecord() {
        if isRecording {
            isRecording = false
            stopRecordingAudio()
        } else {
            isRecording = true
            startRecordingAudio()
        }
    }
    
}


// MARK: Start/stop recording
extension RecordView {
    
    private func startRecordingAudio() {
        recorder.record(self)
        recorder.startMonitoring()
    }
    
    private func stopRecordingAudio() {
        recorder.stopMonitoring()
        recorder.stop()
        progress.animate(toAngle: 0, duration: 0.2, completion: nil)
        decibelLabel.text = "0"
        timeLabel.text = "00:00"
        avgBar.maxDecibelLabel.text = "0"
        avgBar.minDecibelLabel.text = "0"
        avgBar.avgDecibelLabel.text = "0"
    }
    
}


// MARK: Setup view
extension RecordView {
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        recordButton.addTarget(self, action: #selector(startOrStopRecord), for: .touchUpInside)
        
        setupCircleView()
        
        view.addSubview(progress)
        view.addSubview(verticalStack)
        verticalStack.addArrangedSubview(decibelLabel)
        verticalStack.addArrangedSubview(timeLabel)
        verticalStack.addArrangedSubview(timeTitleLabel)
        
//        view.addSubview(chart)
//        setupChart()
//        chart.translatesAutoresizingMaskIntoConstraints = false
        
//        if Constants().isBig {
//            view.addSubview(avgBar)
//        }
        
        view.addSubview(avgBar)
        
        view.addSubview(recordButton)
        
        verticalStack.setCustomSpacing(10, after: decibelLabel)
        
        let constraints: [NSLayoutConstraint]
        
        let constraintsForBigDisplay = [
            verticalStack.centerYAnchor.constraint(equalTo: progress.centerYAnchor),
            verticalStack.centerXAnchor.constraint(equalTo: progress.centerXAnchor),
            
            avgBar.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 5),
            avgBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let constraintsForSmallDisplay = [
            verticalStack.centerYAnchor.constraint(equalTo: progress.centerYAnchor),
            verticalStack.centerXAnchor.constraint(equalTo: progress.centerXAnchor),
            
//            chart.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 10),
//            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            chart.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -10),
            
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        if Constants().isBig {
            constraints = constraintsForBigDisplay
        } else {
            constraints = constraintsForSmallDisplay
        }
        
        NSLayoutConstraint.activate(constraintsForBigDisplay)
    }
    
    // MARK: Setup circle view
    private func setupCircleView() {
        progress.startAngle = -270
        progress.progressThickness = 0.6
        progress.trackThickness = 0.7
        progress.clockwise = true
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        
        progress.set(colors: UIColor(named: "ColorCircleThree")!, UIColor(named: "ColorCircleTwo")!, UIColor(named: "ColorCircleOne")!)
        
        if Constants().screenSize.height <= 667 {
            progress.center = CGPoint(x: view.center.x, y: view.center.y / 1.9)
        } else {
            progress.center = CGPoint(x: view.center.x, y: view.center.y / 1.5)
        }
        
        print(Constants().screenSize.height)
    }
    
}


//// MARK: Setup chart
//extension RecordView: ChartViewDelegate {
//
//    func setupChart() {
//        chart.doubleTapToZoomEnabled = false
//        chart.gridBackgroundColor = .white
//        chart.highlightPerTapEnabled = false
//        chart.clipDataToContentEnabled = false
//
//        var entries = [BarChartDataEntry]()
//
//        for x in 0..<recorder.decibels.count {
//            entries.append(BarChartDataEntry(x: Double(x), y: Double(recorder.decibels[x])))
//        }
//
//        let set = BarChartDataSet(entries: entries)
//        set.colors = ChartColorTemplates.joyful()
//
//        let data = BarChartData(dataSet: set)
//
//        chart.data = data
//    }
//
//}


// MARK: Recorder delegate
extension RecordView: AVAudioRecorderDelegate, RecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Шалость удалась!")
        
        Persist().saveAudio(for: nil)
    }
    
    func recorderDidFailToAchievePermission(_ recorder: Recorder) {
        let alertController = UIAlertController(
            title: "Microphone permissions denied",
            message: "Microphone permissions have been denied for this app. You can change this by going to Settings",
            preferredStyle: .alert
        )

        let cancelButton = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )

        let settingsAction = UIAlertAction(
            title: "Settings",
            style: .default
        ) { _ in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!,
                options: [:],
                completionHandler: nil)
        }

        alertController.addAction(cancelButton)
        alertController.addAction(settingsAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func recorder(_ recorder: Recorder, didCaptureDecibels decibels: Int) {
        let degree = 360 / 96
        
        guard let min = recorder.min else { return }
        guard let max = recorder.max else { return }
        guard let avg = recorder.avg else { return }
        
        let minutes = (recorder.seconds - (recorder.seconds % 60)) / 60
        let seconds = recorder.seconds - (minutes * 60)
        
        let strMinutes: String
        let strSeconds: String
        
        if minutes <= 9 {
            strMinutes = "0\(minutes)"
        } else {
            strMinutes = "\(minutes)"
        }
        
        if seconds <= 9 {
            strSeconds = "0\(seconds)"
        } else {
            strSeconds = "\(seconds)"
        }
        
        timeLabel.text              = "\(strMinutes):\(strSeconds)"
        decibelLabel.text           = "\(decibels)"
        avgBar.avgDecibelLabel.text = "\(avg)"
        avgBar.minDecibelLabel.text = "\(min)"
        avgBar.maxDecibelLabel.text = "\(max)"
        progress.animate(toAngle: Double(degree * decibels), duration: 0.2, completion: nil)
        
//        print(avg)
    }
    
}
