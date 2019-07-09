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


    static func getUrlForString(for value : String) -> URL {
        return URL.init(fileURLWithPath: Bundle.main.path(forResource: value, ofType: "mp3")!)
    }

    static func getUrlForCurrentSong() -> URL {
        return getUrlForString(for: SettingsManager.getAudioFile())
    }

    static func getUrlForCompletionSound() -> URL {
        return getUrlForString(for: Constants.completedAudioFile)
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
