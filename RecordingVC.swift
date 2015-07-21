//
//  RecordingVC.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 29/04/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class RecordingVC: UIViewController ,AVAudioRecorderDelegate  {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var lblRecording: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    var audioRecorder:AVAudioRecorder!
    var data:receivedData!
    var timerCount:Int = 0
        {
        didSet
        {
            let fractionalProgress = Float(timerCount) / 0.10
            let animated = timerCount != 0
            
            progressView.setProgress(fractionalProgress, animated: animated)
        }
    }
    var timer = NSTimer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnRecord.layer.cornerRadius = btnRecord.frame.size.width/2
        btnRecord.clipsToBounds = true
        btnRecord.backgroundColor = UIColor.clearColor()
        btnRecord.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#a63232")), forState: .Normal)
        btnRecord.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#a63232", alpha: 0.8)), forState: .Highlighted)
        btnRecord.layer.borderColor = UIColor.colorWithHex("#900000")?.CGColor
        btnRecord.layer.borderWidth = 3
        
        progressView.setProgress(0, animated: false)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool)
    {
        btnRecord.enabled = true
        lblRecording.hidden = true

        timerCount = 0
        lblTime.text = ""
    }
    
    @IBAction func recordAudio_hold(sender: AnyObject)
    {
        recording()
    }
    
    func recording()
    {
        lblRecording.hidden = false
        btnRecord.enabled = false
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        println("Virbrating")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil , error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: ("startCount"), userInfo: nil, repeats: true)

    }

    func startCount()
    {
        println("counting")
        for i in 0..<1{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            dispatch_async(dispatch_get_main_queue(),
                {
                self.timerCount++
                if self.timerCount == 11
                {
                    self.FinishRecord(self)
                    self.timer.invalidate()
                    println("10")
                }
            })
        })
        }
        
    }

    @IBAction func btnStop_released(sender: AnyObject)
    {
        audioRecorder.pause()
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        timer.invalidate()

    }
    func FinishRecord(sender: AnyObject)
    {
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "dataTransfer"
        {
            let soundEffect:SoundEffectVC = segue.destinationViewController as! SoundEffectVC
            let data = sender as! receivedData
            soundEffect.data = data
        }
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
    
            data = receivedData()
            data.filePathUrl = recorder.url
            data.title = recorder.url.lastPathComponent!
        
            self.performSegueWithIdentifier("dataTransfer", sender: data)

        }
        else
        {
            btnRecord.enabled = true
            println("Error")
        }
        
    }
    @IBAction func btnBack(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
