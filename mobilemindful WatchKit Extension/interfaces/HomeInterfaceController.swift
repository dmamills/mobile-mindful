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
        sessionLabel.setAlpha(0.0)
        startButton.setAlpha(0.0)

        let sessionLength = SettingsManager.getDuration()
        sessionLabel.setText("Start \(sessionLength) minute session")
        animate(withDuration: 1.75) {
            self.sessionLabel.setAlpha(1.0)
            self.startButton.setAlpha(1.0)
        }

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
