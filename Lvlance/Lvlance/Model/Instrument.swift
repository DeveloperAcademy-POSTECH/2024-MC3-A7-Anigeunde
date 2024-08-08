//
//  Instrument.swift
//  Lvlance
//
//  Created by 지영 on 7/25/24.
//

import Foundation

enum InstrumentType: String, CaseIterable {
    case vocal // order 0
    case keyboard // order 1
    case electric // order 2
    case drum // order 3
    case bass // order 4

    var soundLabel: String {
        switch self {
        case .vocal:
            return "singing"
        case .keyboard:
            return "electric_piano"
        case .electric:
            return "electric_guitar"
        case .drum:
            return "drum"
        case .bass:
            return "bass_guitar"
        }
    }

    var krName: String {
        switch self {
        case .vocal:
            return "보컬"
        case .keyboard:
            return "키보드"
        case .electric:
            return "일렉"
        case .drum:
            return "드럼"
        case .bass:
            return "베이스"
        }
    }

    var order: Int {
        switch self {
        case .vocal:
            return 0
        case .keyboard:
            return 1
        case .electric:
            return 2
        case .drum:
            return 3
        case .bass:
            return 4
        }
    }

    var maskImage: String {
        switch self {
        case .vocal:
            return "mask_singing"
        case .keyboard:
            return "mask_electric_piano"
        case .electric:
            return "mask_electric_guitar"
        case .drum:
            return "mask_drum"
        case .bass:
            return "mask_bass_guitar"
        }
    }

    var outlineImage: String {
        switch self {
        case .vocal:
            return "outline_singing"
        case .keyboard:
            return "outline_electric_piano"
        case .electric:
            return "outline_electric_guitar"
        case .drum:
            return "outline_drum"
        case .bass:
            return "outline_bass_guitar"
        }
    }
}


struct Instrument: Identifiable, Hashable {
    let id = UUID()
    let type: InstrumentType
}
