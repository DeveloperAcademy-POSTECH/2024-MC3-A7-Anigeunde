//
//  SongViewModel.swift
//  Lvlance
//
//  Created by 지영 on 8/5/24.
//

import SwiftUI

class SongViewModel: ObservableObject {
    private let coreDataManager = CoreDataManager.shared
    
    @Published var songs: [Song] = []
    @Published var selectedSong: Song? = nil
        
    init() {
        self.setupSongs()
    }
    
    func setupSongs() {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchedSongs = self.coreDataManager.getAllSongs()
            DispatchQueue.main.async {
                self.songs = fetchedSongs
                if self.selectedSong == nil {
                    self.selectedSong = fetchedSongs.first
                }
            }
        }
    }
    
    func createSong(selectedInstruments: [Instrument]) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.coreDataManager.createSongEntity(instruments: selectedInstruments)

            DispatchQueue.main.async {
                self.setupSongs()
            }
        }
    }
    
    func updateInstrument(song: Song, selectedInstruments: [Instrument]) {
        guard let selectedSong = selectedSong else { return }
        
        if !(selectedSong.instruments).elementsEqual(selectedInstruments) {
            coreDataManager.updateSongEntity(song: song, instruments: selectedInstruments)
            songs = coreDataManager.getAllSongs()
            self.selectedSong?.instruments = selectedInstruments
        }
    }
    
    func updateSongTitle(song: Song, newTitle: String) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            songs[index].title = newTitle
            if song.id == selectedSong?.id {
                selectedSong?.title = newTitle
            }
            coreDataManager.updateSongEntity(song: song, title: newTitle)
        }
    }
    
    func deleteSong(song: Song) {
        guard let selectedSong = selectedSong else { return }
        coreDataManager.deleteSongEntity(song: selectedSong)
        setupSongs()
    }
}
