//
//  SongEntity+CoreDataProperties.swift
//  Lvlance
//
//  Created by 지영 on 8/7/24.
//
//

import Foundation
import CoreData


extension SongEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongEntity> {
        return NSFetchRequest<SongEntity>(entityName: "SongEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var instruments: NSSet?

}

// MARK: Generated accessors for instruments
extension SongEntity {

    @objc(addInstrumentsObject:)
    @NSManaged public func addToInstruments(_ value: InstrumentEntity)

    @objc(removeInstrumentsObject:)
    @NSManaged public func removeFromInstruments(_ value: InstrumentEntity)

    @objc(addInstruments:)
    @NSManaged public func addToInstruments(_ values: NSSet)

    @objc(removeInstruments:)
    @NSManaged public func removeFromInstruments(_ values: NSSet)

}

extension SongEntity : Identifiable {

}
