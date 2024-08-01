//
//  CoreDataManager.swift
//  Lvlance
//
//  Created by 지영 on 7/27/24.
//

import CoreData
import Foundation

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "BandSong")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    
    func save() {
        guard context.hasChanges else { return }
        
        do  {
            try context.save()
            print("context에 데이터 저장")
        } catch {
            print("context에 저장 실패:", error.localizedDescription)
        }
    }
    
    
    func createSong(title: String, instruments: [Instrument]) {
        let newSong = SongEntity(context: context)
        newSong.id = UUID()
        newSong.date = Date()
        newSong.title = "새 노래"
        
        for instrument in instruments {
            var newInstrument = InstrumentEntity(context: context)
            newInstrument.type = instrument.type.rawValue
            newInstrument.order = Int16(instrument.order.rawValue)
            newSong.addToInstruments(newInstrument)
        }
        save()
    }
    
    func fetchAllSongs() -> [SongEntity] {
        do {
            let request = SongEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \SongEntity.date, ascending: true)]
            let results = try context.fetch(request)
            return results
        } catch {
            print("데이터 불러오기 실패: \(error.localizedDescription)")
        }
        return []
    }
    
    
    func updateSong(song: SongEntity, title: String, instruments: [Instrument]) {
        song.title = title
        
        if let instruments = song.instruments as? Set<SongEntity> {
            for instrument in instruments {
                context.delete(instrument)
            }
        }
        
        for instrument in instruments {
            var newInstrument = InstrumentEntity(context: context)
            newInstrument.type = instrument.type.rawValue
            newInstrument.order = Int16(instrument.order.rawValue)
            song.addToInstruments(newInstrument)
        }
        
        save()
    }
//    
//    func deleteSong(song: SongEntity) {
//        context.delete(song)
//        save()
//    }
}
