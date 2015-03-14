//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Alexander Ivanov on 28/02/15.
//  Copyright (c) 2015 alex_ivanov. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    private var engine: AVAudioEngine!
    private var audioFile: AVAudioFile!
    
    var recievedAudio: RecordedAudio!
    
    private func playAudioWithEffect(effect: AVAudioUnit) {
        engine.stop()
        engine.reset()
        
        var playerNode = AVAudioPlayerNode()
        engine.attachNode(playerNode)
        
        engine.attachNode(effect)
        
        engine.connect(playerNode, to: effect, format: nil)
        engine.connect(effect, to: engine.outputNode, format: nil)
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        engine.startAndReturnError(nil)
        playerNode.play()
    }
    
    private func playAudioWithPitchAndRate(pitch: Float, rate: Float) {
        // I use the same effect for pitch and rate to get rid from unnecessary AVAudioPlayer object
        
        var pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        pitchEffect.rate = rate
        
        playAudioWithEffect(pitchEffect)
    }
    
    private func playAudioWithEcho(delay: Double) {
        var delayEffect = AVAudioUnitDelay()
        delayEffect.wetDryMix = 50
        delayEffect.delayTime = delay
        
        playAudioWithEffect(delayEffect)
    }
    
    private func playAudioWithReverb(preset: AVAudioUnitReverbPreset) {
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 50
        reverbEffect.loadFactoryPreset(preset)
        
        playAudioWithEffect(reverbEffect)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithPitchAndRate(1, rate: 0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithPitchAndRate(1, rate: 2)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithPitchAndRate(1000, rate: 1)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithPitchAndRate(-1000, rate: 1)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithEcho(0.4)
    }
    
    @IBAction func PlayReverbAudio(sender: UIButton) {
        playAudioWithReverb(AVAudioUnitReverbPreset.Plate)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        engine.stop()
    }
    
}
