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
import Charts


class RecordView: UIViewController {
    
    lazy var chart = BarChartView()
    
    lazy var decibelLabel = Label(style: .decibelHeading, "0")
    lazy var timeLabel = Label(style: .time, "00:00")
    lazy var timeTitleLabel = Label(style: .timeTitle, "TIME")
    
    lazy var progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: view.frame.width / 1.2, height: view.frame.width / 1.2))
    
    lazy var verticalStack = StackView(axis: .vertical)
    
    lazy var avgBar = AvgMinMaxBar()
    
    lazy var recordButton = Button(style: .record, nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension RecordView {
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setupCircleView()
        
        view.addSubview(progress)
        view.addSubview(verticalStack)
        verticalStack.addArrangedSubview(decibelLabel)
        verticalStack.addArrangedSubview(timeLabel)
        verticalStack.addArrangedSubview(timeTitleLabel)
        
        view.addSubview(chart)
        setupChart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        if Constants().isBig {
            view.addSubview(avgBar)
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
            
            chart.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 10),
            chart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chart.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -10),
            
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        if Constants().isBig {
            constraints = constraintsForBigDisplay
        } else {
            constraints = constraintsForSmallDisplay
        }
        
        NSLayoutConstraint.activate(constraints)
        
        progress.animate(toAngle: 90, duration: 2, completion: nil)
    }
    
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


extension RecordView: ChartViewDelegate {
    
    func setupChart() {
        var entries = [BarChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = [NSUIColor(_colorLiteralRed: 253, green: 163, blue: 34, alpha: 1)]
        
        let data = BarChartData(dataSet: set)
        
        chart.data = data
    }
    
}
