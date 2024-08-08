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
    
    var order: Int {
        switch self {
        case .vocal:
            0
        case .keyboard:
            1
        case .bass:
            4
        case .electric:
            2
        case .drum:
            3
        }
    }
    
    var maskImage: String {
        switch self {
        case .vocal:
            "mask_singing"
        case .keyboard:
            "mask_electric_piano"
        case .bass:
            "mask_bass_guitar"
        case .electric:
            "mask_electric_guitar"
        case .drum:
            "mask_drum"
        }
    }
    
    var outlineImage: String {
        switch self {
        case .vocal:
            "outline_singing"
        case .keyboard:
            "outline_electric_piano"
        case .bass:
            "outline_bass_guitar"
        case .electric:
            "outline_electric_guitar"
        case .drum:
            "outline_drum"
        }
    }
    
    var defaultDetectionState: DetectionState {
            switch self {
            case .vocal:
                return DetectionState(presenceThreshold: 0.3, absenceThreshold: 0.15, presenceMeasurementsToStartDetection: 2, absenceMeasurementsToEndDetection: 39)
            case .keyboard:
                return DetectionState(presenceThreshold: 0.06, absenceThreshold: 0.04, presenceMeasurementsToStartDetection: 2, absenceMeasurementsToEndDetection: 33)
            case .bass:
                return DetectionState(presenceThreshold: 0.3, absenceThreshold: 0.15, presenceMeasurementsToStartDetection: 2, absenceMeasurementsToEndDetection: 33)
            case .electric:
                return DetectionState(presenceThreshold: 0.36, absenceThreshold: 0.3, presenceMeasurementsToStartDetection: 3, absenceMeasurementsToEndDetection: 33)
            case .drum:
                return DetectionState(presenceThreshold: 0.1, absenceThreshold: 0.06, presenceMeasurementsToStartDetection: 2, absenceMeasurementsToEndDetection: 36)
            }
        }
    
    var varientSize : Double {
        switch self {
        case .vocal:
            return 1.3
        case .keyboard:
            return 2.1
        case .bass:
            return 1.3
        case .electric:
            return 1.2
        case .drum:
            return 1.5
        }
    }
        
    
    
}

struct Instrument: Identifiable, Hashable {
    let id = UUID()
    let type: InstrumentType
}
