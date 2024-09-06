//
//  Song.swift
//  Lvlance
//
//  Created by 지영 on 7/25/24.
//

import Foundation

struct Song: Identifiable {
    let id: UUID
    var title: String
    var instruments: [Instrument]
}
