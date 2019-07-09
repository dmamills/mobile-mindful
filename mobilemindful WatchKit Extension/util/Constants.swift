//
//  Constants.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-03.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation
import HealthKit

class Constants {

    // UserDefaults
    static let sessionLengthKey = "session_length"
    static let audioCuesKey = "audio_cues"
    static let audioFileKey = "audio_file"
    static let audioFadeOutDuration = 10.0

    static let completedAudioFile = "completed"
    static let audioTitles = ["early", "midday", "late"]
    static let sessionTableDateFormat = "MMM dd hh:mma"

    // Time Tracking
    static let HOUR = 60
    static let DAY = 24 * Constants.HOUR
    static let WEEK = Constants.DAY * 7
    static let MONTH = Constants.WEEK * 4
    static let YEAR = Constants.MONTH * 12

    static let heartImageSize = 20.0

    // Interface Controllers
    static let homeView = "HomeInterfaceController"
    static let meditationView = "MeditationInterfaceController"
    static let completedView = "CompletedInterfaceController"
    static let settingsView = "SettingsInterfaceController"
    static let statsView = "StatsInterfaceController"
    static let mainViews = [Constants.homeView, Constants.settingsView, Constants.statsView]

    // HealthKit Types
    static let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
    static let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!

    static let writeTypes : Set<HKSampleType> = [
        Constants.mindfulType,
    ]

    static let readTypes: Set<HKObjectType> = [
        Constants.mindfulType,
        Constants.heartRateType,
    ]
}
