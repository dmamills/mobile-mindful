//
//  StatsInterfaceController.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-06.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class StatsInterfaceController: WKInterfaceController {

    @IBOutlet weak var totalTimeLabel: WKInterfaceLabel!
    @IBOutlet weak var sessionsTable: WKInterfaceTable!

    let healthStore = HKHealthStore()
    var totalMinutes = 0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        createSessionQuery()
    }

    func createSessionQuery() {
        let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        let query = HKAnchoredObjectQuery(type: mindfulType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) {
            (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in

            guard var samples = samplesOrNil else { return }
            samples = samples.reversed()

            self.sessionsTable.setNumberOfRows(samples.count, withRowType: "SessionRow")
            let rowCount = self.sessionsTable.numberOfRows
            for i in 0..<rowCount {
                let row = self.sessionsTable.rowController(at: i) as! SessionRowController
                let currentSample = samples[i]
                let length = Int(currentSample.endDate.timeIntervalSince(currentSample.startDate) / 60.0)
                self.totalMinutes += length

                row.dateLabel.setText("\(currentSample.startDate.format(to: Constants.sessionTableDateFormat))")
                row.lengthLabel.setText("\(length) minutes")
            }

            self.setTotalTimeLabel()
        }

        healthStore.execute(query)
    }

    func setTotalTimeLabel() {
        print("total minutes: \(totalMinutes)")

        if totalMinutes >= Constants.YEAR {
            totalTimeLabel.setText("\(totalMinutes / Constants.YEAR) years")
        } else if totalMinutes >= Constants.MONTH {
            totalTimeLabel.setText("\(totalMinutes / Constants.MONTH) months")
        } else if totalMinutes >= Constants.WEEK {
            totalTimeLabel.setText("\(totalMinutes / Constants.WEEK) weeks")
        } else if totalMinutes >= Constants.DAY {
            totalTimeLabel.setText("\(totalMinutes / Constants.DAY) days")
        } else if totalMinutes >= Constants.HOUR {
            totalTimeLabel.setText("\(totalMinutes / Constants.HOUR) hours")
        } else {
            totalTimeLabel.setText("\(totalMinutes) minutes")
        }
    }
}
