//
//  Instrument.swift
//  Lvlance
//
//  Created by 지영 on 7/25/24.
//

import Foundation

enum InstrumentType: String, CaseIterable {
    case vocal
    case keyboard
    case bass
    case electric
    case drum
    
    var soundLabel: String {
        switch self {
        case .vocal:
            "singing"
        case .keyboard:
            "electric_piano"
        case .bass:
            "bass_guitar"
        case .electric:
            "electric_guitar"
        case .drum:
            "drum"
        }
    }
    
    var krName: String {
        switch self {
        case .vocal:
            "보컬"
        case .keyboard:
            "키보드"
        case .bass:
            "베이스"
        case .electric:
            "일렉"
        case .drum:
            "드럼"
        }
    }
    
    var image: String {
        switch self {
        case .vocal:
            "vocal"
        case .keyboard:
            "vocal"
        case .bass:
            "vocal"
        case .electric:
            "vocal"
        case .drum:
            "vocal"
        }
    }
}

enum Order: Int {
    case zero
    case one
    case two
    case three
    case four
}

struct Instrument: Identifiable {
    let id: String = UUID().uuidString
    let type: InstrumentType
    var order: Order
}
