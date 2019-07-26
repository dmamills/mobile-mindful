//
//  CompletedInterfaceController.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-06.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class CompletedInterfaceController: WKInterfaceController {

    @IBOutlet weak var sessionLengthLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var discardButton: WKInterfaceButton!
    @IBOutlet weak var saveButton: WKInterfaceButton!
    @IBOutlet weak var heartImage: WKInterfaceImage!
    @IBOutlet weak var averageLabel: WKInterfaceLabel!

    var mindfulSession : MindfulSessionStats!
    var audioPlayer : AVAudioPlayer!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if SettingsManager.getAudioCue() {
            playCompletedSound()
        }

        sessionLengthLabel.setAlpha(0.0)
        heartRateLabel.setAlpha(0.0)
        saveButton.setAlpha(0.0)
        discardButton.setAlpha(0.0)
        heartImage.setAlpha(0.0)
        averageLabel.setAlpha(0.0)

        guard let session = context as? MindfulSessionStats else { return }
        mindfulSession = session
        let minutes = SettingsManager.getDuration()
        heartRateLabel.setText("\(mindfulSession.getAverage())")
        sessionLengthLabel.setText("\(minutes) minutes")

        animate(withDuration: 1.75) {
            self.sessionLengthLabel.setAlpha(1.0)
            self.heartRateLabel.setAlpha(1.0)
            self.saveButton.setAlpha(1.0)
            self.discardButton.setAlpha(1.0)
            self.heartImage.setAlpha(1.0)
            self.averageLabel.setAlpha(1.0)
        }
    }

    func playCompletedSound() {
        audioPlayer = AudioManager.createAudioPlayer(for: AudioManager.getUrlForCompletionSound())

        if audioPlayer != nil {
            audioPlayer.volume = 1.0
            audioPlayer.numberOfLoops = 1
            audioPlayer.play()
        }
    }

    func goHome() {
        WKInterfaceController.reloadRootPageControllers(withNames: Constants.mainViews, contexts: Constants.mainViews, orientation: .horizontal, pageIndex: 0)
    }

    @IBAction func onHomePressed() {
        HealthKitManager.saveSession(session: mindfulSession, successCallback: { success in
            if success {
                self.goHome()
            } else {
                self.presentAlert(withTitle: "Unable to Save!", message: "Check your Health permissions", preferredStyle:.alert, actions: [WKAlertAction(title: "Okay", style: .default, handler: self.goHome)])
            }
        })
    }

    @IBAction func onDiscardPressed() {
        goHome()
    }
}
