//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alexander Ivanov on 24/02/15.
//  Copyright (c) 2015 alex_ivanov. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var recordingPaused = false
    
    private func initAudioRecorder() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        recordingButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.text = "Recording"
        stopButton.hidden = false
        pauseButton.hidden = false
        
        if (!recordingPaused) { initAudioRecorder() } // We don't need to initiate audioRecorder of the recording was paused
        else { recordingPaused = false }
        audioRecorder.record()
    }
    
    @IBAction func pauseRecordAudio(sender: UIButton) {
        audioRecorder.pause()
        recordingLabel.text = "Tap to Resume Recording"
        recordingPaused = true
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        recordingLabel.text = "Tap to Record"
        recordingButton.enabled = false
        
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            recordingButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio
            playSoundsVC.recievedAudio = data
            
            
        }
    }
}

