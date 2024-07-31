//
//  Device.swift
//  Lvlance
//
//  Created by 이종선 on 7/31/24.
//


struct Device: Hashable, Identifiable {
    static let invalid = Device(id: "-1", name: "No audio device available", hasGainControl: false, currentGain: 0, minGain: 0, maxGain: 1)
    let id: String
    let name: String
    var hasGainControl: Bool
    var currentGain: Float
    var minGain: Float
    var maxGain: Float
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
