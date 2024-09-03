//
//  SoundIdentifier.swift
//  Lvlance
//
//  Created by 이종선 on 7/29/24.
//


struct SoundIdentifier: Hashable {
    let instrument: InstrumentType
    
    var labelName: String {
        instrument.soundLabel
    }
    
    var displayName: String {
        String(localized: instrument.title)
    }
}
