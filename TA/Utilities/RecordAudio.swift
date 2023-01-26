//
//  RecordAudio.swift
//  TA
//
//  Created by Roberto Luiz Veiga Junior on 25/01/23.
//

import Foundation
import UIKit
import AVFAudio

class RecordAudio: UIView , AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var recordButton : UIButton!
//    var playButton : UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewDidLoad()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewDidLoad()
    }
    
    func viewDidLoad() {
        //setup Recorder
        self.setupView()
    }
    
    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    func loadRecordingUI() {
        recordButton = UIButton.init(frame: CGRect(x: 10, y: 10, width: 300, height: 100))
        recordButton.isEnabled = true
        recordButton.setTitle("Recording...    Stop Recording", for: .normal)
        recordButton.addTarget(self, action: #selector(finishRecording), for: .touchUpInside)
        self.addSubview(recordButton)
        startRecording()
    }
    
    @objc func recordAudioButtonTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            //recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    @objc func finishRecording(success: Bool = false) {
        audioRecorder.stop()
        audioRecorder = nil
        
//        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
//        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
//            // recording failed :(
//        }
        playAudioFromURL()
        recordButton.isEnabled = true
    }
    
    @IBAction func playAudioButtonTapped(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Play"){
            recordButton.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            preparePlayer()
            audioPlayer.play()
        } else {
            audioPlayer.stop()
            sender.setTitle("Play", for: .normal)
        }
    }
    
    func preparePlayer() {
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    //MARK: Delegates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playAudioFromURL()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    
    //MARK: To upload video on server
    
    func playAudioFromURL() {
        let url = getFileURL()
        downloadFileFromURL(url: url)
    }
    
    @objc func stopAudioFromURL() {
        audioPlayer.stop()
    }
    
    func downloadFileFromURL(url: URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            self.play(url: url!)
        }
        downloadTask.resume()
    }
    func play(url:URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 5.0
            //preparePlayer()
            audioPlayer.play()
            //send url to server
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
}
