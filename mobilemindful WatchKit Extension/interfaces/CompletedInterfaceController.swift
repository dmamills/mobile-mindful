//
//  CompletedInterfaceController.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-06.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import WatchKit
import Foundation

class CompletedInterfaceController: WKInterfaceController {

    @IBOutlet weak var sessionLengthLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!

    var mindfulSession : MindfulSessionStats!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        guard let session = context as? MindfulSessionStats else { return }
        mindfulSession = session
        let minutes = SettingsManager.getDuration()
        heartRateLabel.setText("\(mindfulSession.getAverage())")
        sessionLengthLabel.setText("\(minutes) minutes")
    }

    func goHome() {
        WKInterfaceController.reloadRootPageControllers(withNames: Constants.mainViews, contexts: Constants.mainViews, orientation: .horizontal, pageIndex: 0)
    }

    @IBAction func onHomePressed() {
        HealthKitManager.saveSession(session: mindfulSession, successCallback: { success in
            if success {
                self.goHome()
            } else {
                self.presentAlert(withTitle: "Unable to Save", message: "Check your Health permissions", preferredStyle:.alert, actions: [WKAlertAction(title: "Okay", style: .default, handler: self.goHome)])
            }
        })
    }
    
    @IBAction func onDiscardPressed() {
        goHome()
    }
}
