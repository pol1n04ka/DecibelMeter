//
//  Chart.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/29/21.
//

import Foundation
import UIKit
import SwiftCharts


class Chart: BarsChart {
    
    override init(frame: CGRect, chartConfig: BarsChartConfig, xTitle: String, yTitle: String, bars barModels: [(String, Double)], color: UIColor, barWidth: CGFloat, animDuration: Float = 0.5, animDelay: Float = 0.5, horizontal: Bool = false) {
        super.init(frame: frame, chartConfig: chartConfig, xTitle: "", yTitle: "", bars: barModels, color: .white, barWidth: 5)
        
        
    }
    
    init(chartConfig: BarsChartConfig, barModels: [(String, Double)]) {
        super.init(frame: .zero, chartConfig: chartConfig, xTitle: "", yTitle: "", bars: barModels, color: .white, barWidth: 5)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
