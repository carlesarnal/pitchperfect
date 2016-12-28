//
//  RecordSoundsViewController.swift
//  PerfectPitch
//
//  Created by Carles Arnal Castelló on 28/12/16.
//  Copyright © 2016 carlesarnal. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var startRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRecordingButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

  
    
    
    @IBAction func startRecording(_ sender: Any) {
        startRecordingButton.isEnabled = false
        stopRecordingButton.isEnabled = true
        recordingLabel.text = "Recording in Progress"
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    
    
    @IBAction func stopRecording(_ sender: Any) {
        stopRecordingButton.isEnabled = false
        startRecordingButton.isEnabled = true
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

