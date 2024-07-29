//
//  SoundIdentifier.swift
//  Lvlance
//
//  Created by 이종선 on 7/29/24.
//


struct SoundIdentifier: Hashable {
    
    var labelName: String
    var displayName: String
    
    init(instrument: InstrumentType){
        self.labelName = instrument.soundLabel
        self.displayName = instrument.krName
    }
}
