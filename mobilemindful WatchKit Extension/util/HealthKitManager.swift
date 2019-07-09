//
//  HealthKitManager.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-04.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject {

    typealias SuccessCallback = (_ success : Bool) -> ()
    typealias HeartRateCallback = (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> ()

    static let healthKitStore = HKHealthStore()
    static let heartRateUnit : HKUnit = HKUnit(from: "count/min")
    static let heartRateType : HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!

    static func authorizeHealthKit(_ callback : @escaping SuccessCallback) {
        healthKitStore.requestAuthorization(toShare: Constants.writeTypes, read: Constants.readTypes) { (success, error) in
            callback(success)
        }
    }

    static func getHeartRateQuery(startDate : Date, callback : @escaping HeartRateCallback) -> HKAnchoredObjectQuery {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: [])
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: callback)

        return query
    }

    static func saveSession(session : MindfulSessionStats, successCallback : @escaping SuccessCallback) {
        let endDate = session.startDate.addingTimeInterval(session.duration)
        let mindfulSample = HKCategorySample(type: Constants.mindfulType, value: 0, start: session.startDate, end: endDate)
        healthKitStore.save(mindfulSample, withCompletion: { (success, error) in
            successCallback(success)
        })
    }
}
