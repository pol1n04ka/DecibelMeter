//
//  PreRecord.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 12/11/21.
//


class RecordInfo {
    
    let name: String
    let length: String
    let avg: UInt8
    let min: UInt8
    let max: UInt8
    
    init(name: String, length: String, avg: UInt8, min: UInt8, max: UInt8) {
        self.name = name
        self.length = length
        self.avg = avg
        self.min = min
        self.max = max
    }
}
