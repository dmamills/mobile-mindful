//
//  AudioManager.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-07.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {

    static func getUrlForCurrentSong() -> URL {
        let selectedSong = SettingsManager.getAudioFile()
        //let selectedSong = Constants.audioFile
        return URL.init(fileURLWithPath: Bundle.main.path(forResource: selectedSong, ofType: "mp3")!)
    }

    static func createAudioPlayer(for url : URL) -> AVAudioPlayer? {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            return player
        } catch {
            return nil
        }
    }
}
