//
//  PreRecord.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 12/11/21.
//

import Foundation


public struct RecordInfo {
    
    let id:     UUID
    var name:   String?
    let length: String
    let avg:    UInt8
    let min:    UInt8
    let max:    UInt8
    let date:   Date
    
    init(
        id:     UUID,
        name:   String?,
        length: String,
        avg:    UInt8,
        min:    UInt8,
        max:    UInt8,
        date:   Date
    ) {
        self.id     = id
        self.name   = name
        self.length = length
        self.avg    = avg
        self.min    = min
        self.max    = max
        self.date   = date
    }
}
