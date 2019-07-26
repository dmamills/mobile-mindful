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
    @IBOutlet weak var titleLabel: WKInterfaceImage!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateImage: WKInterfaceImage!
    @IBOutlet weak var volumeControl: WKInterfaceVolumeControl!

    let healthStore : HKHealthStore = HKHealthStore()
    let avSession = AVAudioSession()
    var player : AVAudioPlayer?

    var timer : Timer!
    var fadeoutTimer : Timer?
    var heartRateQuery : HKAnchoredObjectQuery?
    var session = WKExtendedRuntimeSession()
    var mindfulSession : MindfulSessionStats!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        session.delegate = self
        guard HKHealthStore.isHealthDataAvailable() == true else {
            dismiss()
            return
        }

        if SettingsManager.getAudioCue() {
            setupAudio(onSetup: startSession)
        } else {
            volumeControl.setAlpha(0.0)
            startSession()
        }
    }

    func startSession() {
        DispatchQueue.main.async {
            print("MeditationInterfaceControllere#startSession")
            self.session.start()
            self.mindfulSession = MindfulSessionStats()
            self.timer = Timer.scheduledTimer(withTimeInterval: self.mindfulSession.duration, repeats: false, block: self.onDone)
            self.timerLabel.setDate(self.timer.fireDate)
            self.timerLabel.start()
            self.createHeartRateQuery()

            if self.player != nil && self.player!.isPlaying {
                self.fadeoutTimer = Timer.scheduledTimer(withTimeInterval: self.mindfulSession.duration - Constants.audioFadeOutDuration, repeats: false, block: {_ in
                    self.player?.setVolume(0.0, fadeDuration: Constants.audioFadeOutDuration)
                })
            }
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

            if !success {
                DispatchQueue.main.async {
                    WKInterfaceController.reloadRootPageControllers(withNames: Constants.mainViews, contexts: Constants.mainViews, orientation: .horizontal, pageIndex: 0)
                }
            } else {
                if let audioPlayer = self.player {
                    audioPlayer.numberOfLoops = -1
                    audioPlayer.play()
                }

                onSetup()
            }
        })
    }

    func animateHeart(bpm : Int) {
        self.animate(withDuration: 0.5) {
            let imageSize = CGFloat(Float(Constants.heartImageSize) * Float(bpm) / 100.0)
            self.heartRateImage.setWidth(imageSize)
            self.heartRateImage.setHeight(imageSize)
        }
    }

    func onSample(anchorObjectQuery :HKAnchoredObjectQuery, samples : [HKSample]?, deletedObjects: [HKDeletedObject]?, queryAnchor: HKQueryAnchor?, error : Error?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        guard let sample = heartRateSamples.first else { return }

        DispatchQueue.main.async {
            let value = Int(sample.quantity.doubleValue(for: HealthKitManager.heartRateUnit))
            self.mindfulSession.add(value)
            self.heartRateLabel.setText(String(value))
            self.animateHeart(bpm: value)
        }
    }

    func onDone(_ t : Timer) {
        print("Timer completed.")
        if session.state == .running {
            session.invalidate()
        }

        if player != nil && player!.isPlaying {
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
