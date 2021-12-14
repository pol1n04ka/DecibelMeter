//
//  Record.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit
import KDCircularProgress
import SwiftCharts
import AVFAudio


class RecordView: UIViewController {
    
    private var isRecording = false
    
    // MARK: Audio recorder & persist
    let recorder = Recorder()
    let persist  = Persist()
    var info: RecordInfo!
    
    // MARK: UI elements
    lazy var decibelLabel   = Label(style: .decibelHeading, "0")
    lazy var timeLabel      = Label(style: .time, "00:00")
    lazy var timeTitleLabel = Label(style: .timeTitle, "TIME")
    
    lazy var progress = KDCircularProgress(
        frame: CGRect(x: 0, y: 0, width: view.frame.width / 1.2, height: view.frame.width / 1.2)
    )
    
    lazy var verticalStack = StackView(axis: .vertical)
    
    lazy var avgBar = AvgMinMaxBar()
    lazy var containerForSmallDisplay: UIView = {
        let v = UIView()
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        
        return v
    }()
    
    lazy var recordButton = Button(style: .record, nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recorder.delegate   = self
        recorder.avDelegate = self
        
        setupView()
        
        if Constants().isRecordingAtLaunchEnabled {
            isRecording = true
            startRecordingAudio()
        }
        
        requestPermissions()
    }
    
    private func requestPermissions() {
        if !Constants().isFirstLaunch {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in }
            Constants().isFirstLaunch = true
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
            recordButton.setImage(UIImage(named: "Microphone"), for: .normal)
        } else {
            isRecording = true
            startRecordingAudio()
            recordButton.setImage(UIImage(named: "Stop"), for: .normal)
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
        if recorder.min != nil, recorder.avg != nil, recorder.max != nil {
            self.info = RecordInfo(
                id: UUID(),
                name: nil,
                length: timeLabel.text!,
                avg: UInt8(recorder.avg!),
                min: UInt8(recorder.min!),
                max: UInt8(recorder.max!),
                date: Date()
            )
            
            recorder.stopMonitoring()
            recorder.stop()
            progress.animate(toAngle: 0, duration: 0.2, completion: nil)
            decibelLabel.text = "0"
            timeLabel.text = "00:00"
            avgBar.maxDecibelLabel.text = "0"
            avgBar.minDecibelLabel.text = "0"
            avgBar.avgDecibelLabel.text = "0"
            
            let alert = UIAlertController(
                title: "Recording name",
                message: nil, preferredStyle: .alert
            )
            
            let cancel = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
            
            let save = UIAlertAction(
                title: "Save",
                style: .default,
                handler: { _ in
                    let name = alert.textFields![0].text
                    
                    if name == "" {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                        self.info.name = dateFormatter.string(from: self.info.date as Date)
                    } else {
                        self.info.name = name
                    }
                    
                    self.persist.saveAudio(info: self.info)
                }
            )
            
            alert.addTextField { textField in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                textField.placeholder = "\(dateFormatter.string(from: self.info.date as Date))"
            }
            
            alert.addAction(cancel)
            alert.addAction(save)
            
            present(alert, animated: true, completion: nil)
        }
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
        
        if Constants().isBig {
            view.addSubview(containerForSmallDisplay)
            containerForSmallDisplay.addSubview(avgBar)
        } else {
            view.addSubview(containerForSmallDisplay)
            containerForSmallDisplay.addSubview(avgBar)
        }
    
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
            
            containerForSmallDisplay.topAnchor.constraint(equalTo: progress.bottomAnchor),
            containerForSmallDisplay.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerForSmallDisplay.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerForSmallDisplay.bottomAnchor.constraint(equalTo: recordButton.topAnchor),
            
            avgBar.centerXAnchor.constraint(equalTo: containerForSmallDisplay.centerXAnchor),
            avgBar.centerYAnchor.constraint(equalTo: containerForSmallDisplay.centerYAnchor, constant: -40),
            
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
//        if Constants().isBig {
//            constraints = constraintsForBigDisplay
//        } else {
//            constraints = constraintsForSmallDisplay
//        }
        constraints = constraintsForSmallDisplay
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Setup circle view
    private func setupCircleView() {
        progress.startAngle = -270
        progress.progressThickness = 0.6
        progress.trackThickness = 0.7
        progress.clockwise = true
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.trackColor = UIColor(named: "BackgroundColorTabBar")!
        progress.set(colors: UIColor(named: "ColorCircleThree")!, UIColor(named: "ColorCircleTwo")!, UIColor(named: "ColorCircleOne")!)
        
        if Constants().screenSize.height <= 667 {
            progress.center = CGPoint(x: view.center.x, y: view.center.y / 1.9)
        } else {
            progress.center = CGPoint(x: view.center.x, y: view.center.y / 1.5)
        }
        
        if Constants().isBig {
            progress.center = CGPoint(x: view.center.x, y: view.center.y / 1.6)
        }
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
    func recorder(_ recorder: Recorder, didFinishRecording info: RecordInfo) {
//        persist.saveAudio(for: nil, info: info)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Record finished")
//        persist.saveAudio(for: nil)
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
    }
    
}
