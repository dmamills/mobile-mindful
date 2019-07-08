//
//  SessionHeartRate.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-06.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation


class MindfulSessionStats {

    public var startDate : Date
    public var duration : TimeInterval
    private var entries : Array<Int>
    private var highest : Int
    private var lowest : Int

    init(startDate : Date) {
        self.startDate = startDate
        duration = Double(SettingsManager.getDuration()) * 60.0
        entries = []
        highest = 0
        lowest = Int.max
    }

    convenience init() {
        self.init(startDate: Date())
    }

    func getHighest() -> Int { return highest }

    func getLowest() -> Int { return lowest }

    func add(_ hr : Int) {
        entries.append(hr)
        if hr > highest {
            highest = hr
        }

        if hr < lowest {
            lowest = hr
        }
    }

    func getAverage() -> Int {
        if entries.count == 0 {
            return 0
        }

        return entries.reduce(0, {(acc, v) in
            return acc + v
        }) / entries.count
    }
}
