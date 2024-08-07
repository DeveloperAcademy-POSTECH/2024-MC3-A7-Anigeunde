//
//  InstrumentEntity+CoreDataProperties.swift
//  Lvlance
//
//  Created by 지영 on 8/7/24.
//
//

import Foundation
import CoreData


extension InstrumentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstrumentEntity> {
        return NSFetchRequest<InstrumentEntity>(entityName: "InstrumentEntity")
    }

    @NSManaged public var instrumentId: UUID?
    @NSManaged public var type: String?

}

extension InstrumentEntity : Identifiable {

}
