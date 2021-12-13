//
//  PreRecord.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 12/11/21.
//

import Foundation


class RecordInfo {
    
    let id: UUID
    let name: String
    let length: String
    let avg: UInt8
    let min: UInt8
    let max: UInt8
    let url: URL
    
    init(
        id: UUID,
        name: String,
        length: String,
        avg: UInt8,
        min: UInt8,
        max: UInt8,
        url: URL
    ) {
        self.id = id
        self.name = name
        self.length = length
        self.avg = avg
        self.min = min
        self.max = max
        self.url = url
    }
}
