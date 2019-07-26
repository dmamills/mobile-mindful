//
//  SettingsInterfaceController.swift
//  mobilemindful WatchKit Extension
//
//  Created by Daniel Mills on 2019-07-03.
//  Copyright © 2019 Daniel Mills. All rights reserved.
//

import WatchKit
import Foundation

class SettingsInterfaceController: WKInterfaceController {

    @IBOutlet weak var audioCueSwitch: WKInterfaceSwitch!
    @IBOutlet weak var sessionLengthSlider: WKInterfaceSlider!
    @IBOutlet weak var sessionLengthLabel: WKInterfaceLabel!
    @IBOutlet weak var audioPicker: WKInterfacePicker!

    var sessionLength = 0

    override func willActivate() {
        super.willActivate()

        sessionLength = SettingsManager.getDuration()
        let audioCues = SettingsManager.getAudioCue()

        sessionLengthSlider.setValue(Float(sessionLength))
        sessionLengthLabel.setText("\(sessionLength) minutes")
        audioCueSwitch.setOn(audioCues)
        audioCueSwitch.setTitle(audioCues ? "On" : "Off")
        setupAudioPicker()

    }

    func setupAudioPicker() {
        var pickerItems : [WKPickerItem] = []
        for i in 0..<Constants.audioTitles.count {
            let item = WKPickerItem()
            item.title = Constants.audioTitles[i]
            pickerItems.append(item)
        }

        audioPicker.setItems(pickerItems)
        audioPicker.setSelectedItemIndex(SettingsManager.getAudioFileIndex())
        audioPicker.setEnabled(SettingsManager.getAudioCue())

    }

    @IBAction func onAudioCueChanged(_ value: Bool) {
        WKInterfaceDevice.current().play(.success)
        audioCueSwitch.setTitle(value ? "On" : "Off")
        SettingsManager.setAudioCue(enabled: value)
        audioPicker.setEnabled(value)
    }

    @IBAction func onSessionLengthChanged(_ value: Float) {
        let hapticType : WKHapticType = sessionLength > Int(value) ? .directionDown : .directionUp

        WKInterfaceDevice.current().play(hapticType)
        sessionLength = Int(value)
        sessionLengthLabel.setText("\(sessionLength) minutes")
        SettingsManager.setDuration(hours: sessionLength)
    }

    @IBAction func onAudioChanged(_ value: Int) {
        SettingsManager.setAudioFile(index: value)
    }
}
