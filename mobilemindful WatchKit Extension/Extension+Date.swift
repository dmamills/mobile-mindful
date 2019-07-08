//
//  Extension+Date.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-07.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import Foundation

extension Date {
    func format(to format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
