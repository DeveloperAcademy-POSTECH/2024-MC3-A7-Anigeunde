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
    
    func updateSongTitle(song: Song, title: String) {
        guard let selectedSong = selectedSong else { return }
        
        if selectedSong.title != title {
            coreDataManager.updateSongEntity(song: song, title: title)
            songs = coreDataManager.getAllSongs()
            self.selectedSong?.title = title
        }
    }
    
    func deleteSong(song: Song) {
        guard let selectedSong = selectedSong else { return }
        coreDataManager.deleteSongEntity(song: selectedSong)
        setupSongs()
    }
}
