//
//  MeditationInterfaceController.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-03.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import WatchKit
import HealthKit
import Foundation
import AVFoundation

class MeditationInterfaceController: WKInterfaceController {

    @IBOutlet weak var timerLabel: WKInterfaceTimer!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateImage: WKInterfaceImage!

    let healthStore : HKHealthStore = HKHealthStore()
    let avSession = AVAudioSession()
    var player : AVAudioPlayer?

    var timer : Timer!
    var heartRateQuery : HKAnchoredObjectQuery?
    var session = WKExtendedRuntimeSession()
    var mindfulSession : MindfulSessionStats!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        session.delegate = self
        guard HKHealthStore.isHealthDataAvailable() == true else {
            titleLabel.setText("not available")
            dismiss()
            return
        }

        if SettingsManager.getAudioCue() {
            setupAudio(onSetup: startSession)
        } else {
            session.start()
            startSession()
        }
    }

    func startSession() {
        DispatchQueue.main.async {
            print("MeditationInterfaceControllere#startSession")
            self.mindfulSession = MindfulSessionStats()
            self.timer = Timer.scheduledTimer(withTimeInterval: self.mindfulSession.duration, repeats: false, block: self.onDone)
            self.timerLabel.setDate(self.timer.fireDate)
            self.timerLabel.start()
            self.createHeartRateQuery()
        }
    }

    func createHeartRateQuery() {
        heartRateQuery = HealthKitManager.getHeartRateQuery(startDate: mindfulSession.startDate, callback: onSample)
        heartRateQuery!.updateHandler = onSample
        healthStore.execute(heartRateQuery!)
    }

    func setupAudio(onSetup : @escaping () -> ()) {
        do {
            try avSession.setCategory(.playback, mode:  .default, policy: .longFormAudio, options: [])
        } catch {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }

        player = AudioManager.createAudioPlayer(for: AudioManager.getUrlForCurrentSong())

        avSession.activate(options: [], completionHandler: { (success, error) in
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                return
            }

            if let audioPlayer = self.player {
                audioPlayer.numberOfLoops = -1
                audioPlayer.play()
            } else {
                self.session.start()
            }

            //self.player?.setVolume(0.0, fadeDuration: 5.0)
            onSetup()
        })
    }

    func onSample(anchorObjectQuery :HKAnchoredObjectQuery, samples : [HKSample]?, deletedObjects: [HKDeletedObject]?, queryAnchor: HKQueryAnchor?, error : Error?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        guard let sample = heartRateSamples.first else { return }

        DispatchQueue.main.async {
            let value = Int(sample.quantity.doubleValue(for: HealthKitManager.heartRateUnit))
            self.mindfulSession.add(value)
            self.heartRateLabel.setText(String(value))
        }
    }

    func onDone(_ t : Timer) {
        print("Timer completed.")
        if session.state == .running {
            session.invalidate()
        } else {
            player?.stop()
        }

        healthStore.stop(heartRateQuery!)

        DispatchQueue.main.async {
            WKInterfaceController.reloadRootPageControllers(withNames: [Constants.completedView], contexts: [self.mindfulSession!], orientation: .horizontal, pageIndex: 0)
        }
    }
}

extension MeditationInterfaceController : WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {}
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {}
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {}
}
