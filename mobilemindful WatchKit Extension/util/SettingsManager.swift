//
//  SettingsManager.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-06.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation


class SettingsManager {

    static func getDuration() -> Int {
        var sessionLength = UserDefaults.standard.integer(forKey: Constants.sessionLengthKey)
        if sessionLength < 1 {
            sessionLength = 5
        }

        return sessionLength
    }

    static func getAudioCue() -> Bool {
       return UserDefaults.standard.bool(forKey: Constants.audioCuesKey)
    }

    static func getAudioFileIndex() -> Int {
        return UserDefaults.standard.integer(forKey: Constants.audioFileKey)
    }
    static func getAudioFile() -> String {
        let index = UserDefaults.standard.integer(forKey: Constants.audioFileKey)
        return Constants.audioTitles[index]
    }

    static func setDuration(hours : Int) {
        UserDefaults.standard.set(hours, forKey: Constants.sessionLengthKey)
        UserDefaults.standard.synchronize()
    }

    static func setAudioCue(enabled : Bool) {
        UserDefaults.standard.set(enabled, forKey: Constants.audioCuesKey)
        UserDefaults.standard.synchronize()
    }

    static func setAudioFile(index: Int) {
        UserDefaults.standard.set(index, forKey: Constants.audioFileKey)
        UserDefaults.standard.synchronize()
    }
}
