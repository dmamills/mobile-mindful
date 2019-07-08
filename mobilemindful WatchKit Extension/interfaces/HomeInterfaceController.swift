//
//  InterfaceController.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-03.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import WatchKit
import Foundation

class HomeInterfaceController: WKInterfaceController {

    @IBOutlet weak var sessionLabel: WKInterfaceLabel!
    @IBOutlet weak var startButton: WKInterfaceButton!

    override func willActivate() {
        super.willActivate()
        let sessionLength = SettingsManager.getDuration()
        sessionLabel.setText("Start \(sessionLength) minute session")
        HealthKitManager.authorizeHealthKit { success in
            if success {
                self.startButton.setEnabled(true)
            } else {
                // TODO: warn about healthkit authorization
                self.startButton.setEnabled(false)
            }
        }
    }
    
    @IBAction func onStartPressed() {
        WKInterfaceController.reloadRootPageControllers(withNames: [Constants.meditationView], contexts: [Constants.meditationView], orientation: .horizontal, pageIndex: 0)
    }
}
