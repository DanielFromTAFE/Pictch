//
//  SoundEffectVC.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 29/04/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class SoundEffectVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate  , UITableViewDelegate ,AVAudioRecorderDelegate{
    
    var audioPlayer:AVAudioPlayer!
    var data:receivedData!
    var audioRecorder:AVAudioRecorder!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var buffer:AVAudioPCMBuffer!
    var hasImg = false
    var Button:UIButton = UIButton()

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ScrollingView: UIScrollView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnUpload.layer.cornerRadius = btnUpload.frame.size.width/2
        btnUpload.backgroundColor = UIColor.clearColor()
        btnUpload.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#0b8800")), forState: .Normal)
        btnUpload.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#0b8800", alpha: 0.8)), forState: .Highlighted)
        btnUpload.layer.borderColor = UIColor.colorWithHex("#075500")?.CGColor
        btnUpload.layer.borderWidth = 3
        btnUpload.clipsToBounds = true

        audioPlayer = AVAudioPlayer(contentsOfURL:data.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: data.filePathUrl, error: nil)
        
        buffer = AVAudioPCMBuffer(PCMFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
        audioFile.readIntoBuffer(buffer, error: nil)
        

        let scrollingView = buttonsView(CGSizeMake(80.0,80.0), buttonCount: 7)
        ScrollingView.contentSize = scrollingView.frame.size
        
        ScrollingView.addSubview(scrollingView)
        ScrollingView.showsHorizontalScrollIndicator = true
        ScrollingView.indicatorStyle = .Default

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - sound effect
    func Play_Normal(sender: AnyObject)
    {
        audioPlayer.stop()
        audioPlayer.play()
    }
     func Play_Slow(sender: AnyObject)
    {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }
    
     func Play_Fast(sender: AnyObject)
     {
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
     func Play_Chipmunk(sender: AnyObject)
    {
        audioWithVariablePitch(1000)
    }
    func audioWithVariablePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile( audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    func Play_Darthvader(sender: AnyObject)
    {
        audioWithVariablePitch2(-1000)
    }
    
    func audioWithVariablePitch2(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()  
        
    }
    
     func Play_Robot(sender: AnyObject)
     {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var distortion = AVAudioUnitDistortion()
        distortion.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechRadioTower)
        distortion.wetDryMix = 25
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(distortion)
        audioEngine.connect(audioPlayerNode, to: distortion, format: buffer.format)
        audioEngine.connect(distortion, to: audioEngine.mainMixerNode, format: buffer.format)
        
        audioPlayerNode.scheduleBuffer(buffer, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    func Play_Angel(sender: AnyObject)
    {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverb.wetDryMix = 50
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(reverb)
        audioEngine.connect(audioPlayerNode, to: reverb, format: buffer.format)
        audioEngine.connect(reverb, to: audioEngine.mainMixerNode, format: buffer.format)
        
        audioPlayerNode.scheduleBuffer(buffer, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    

    //MARK - choose photo
    @IBAction func choosePhoto(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        println("add photo")
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let theInfo:NSDictionary = info as NSDictionary
        var image:UIImage = theInfo.objectForKey(UIImagePickerControllerEditedImage) as! UIImage
        //makeRoomForImage()
        println("picking up a photo")
        hasImg = true
        self.image.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    //MARK - scroll view

    func buttonsView(buttonSize:CGSize , buttonCount:Int) -> UIView
    {
        var buttonView = UIView()
        buttonView.backgroundColor = UIColor.darkGrayColor()
        buttonView.frame.origin = CGPointMake(0,0)
        
        let padding = CGSizeMake(10, 10)
        buttonView.frame.size.width = (buttonSize.width + padding.width) * CGFloat(buttonCount)
        buttonView.frame.size.height = (buttonSize.height +  2.0 * padding.height)
        
        var ButtonPosition = CGPointMake(padding.width * 0.5, padding.height)
        let buttonIncrement = buttonSize.width + padding.width
        
        
        var buttons = ["N","F","S","D","C","A","R"]


        for button in buttons
            {
            println("start loop" )
                

                Button = UIButton(frame: CGRect(x:10, y: 20, width: 80, height: 80))
                Button.frame.origin = ButtonPosition
                ButtonPosition.x = ButtonPosition.x + buttonIncrement
                Button.layer.cornerRadius = 3
                Button.clipsToBounds = true
                Button.backgroundColor = UIColor.groupTableViewBackgroundColor()
                Button.setTitle("\(button)", forState: UIControlState.Normal)
                Button.titleLabel?.text = ("\(button)")
                Button.titleColorForState(UIControlState.Normal)
                Button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                Button.titleLabel?.font = UIFont(name:"AppleSDGothicNeo-Thin", size: 30.0)
                Button.setBackgroundImage(UIImage.imageWithColor(UIColor.colorWithHex("#b8b4af", alpha: 0.5)), forState: .Highlighted)
                
                Button.addTarget(self, action: "check:", forControlEvents: UIControlEvents.TouchUpInside)
            
                buttonView.addSubview(Button)
        }
        println("end loop" )

        return buttonView
    }
    func check(sender:UIButton){
        println("checking effect method")
        
        let str:String = sender.titleLabel!.text!
        switch str{
            case "F":
            Play_Fast(self)

            case "S":
            Play_Slow(self)
            sender.backgroundColor = UIColor.grayColor()

            case "D":
            Play_Darthvader(self)
            sender.backgroundColor = UIColor.grayColor()


            case "C":
            Play_Chipmunk(self)
            sender.backgroundColor = UIColor.grayColor()


            case "R":
            Play_Robot(self)
            sender.backgroundColor = UIColor.grayColor()


            case "A":
            Play_Angel(self)
            sender.backgroundColor = UIColor.grayColor()


        default:
            println("default")
            Play_Normal(self)
            sender.backgroundColor = UIColor.grayColor()

        }

        println("You have chosen: \(sender.titleLabel?.text)")

    }

    
    //MARK upload
    @IBOutlet weak var btnUpload: UIButton!
    
    @IBAction func Upload(sender: AnyObject)
    {
        
        var storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc:SWRevealViewController = storyboard.instantiateViewControllerWithIdentifier("SWRevealViewController") as! SWRevealViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
            var postObj = PFObject(className: "Post")
            postObj["userName"] = PFUser.currentUser()!.username
            postObj["profileName"] = PFUser.currentUser()?.valueForKey("profileName") as! String
            postObj["icon"] = PFUser.currentUser()?.valueForKey("photo") as! PFFile
            
            if self.hasImg == true
            {
                postObj["hasImage"] = "YES"
                
                let imageData = UIImagePNGRepresentation(self.image.image)
                let imageFile = PFFile(name: "CommentImg", data: imageData)
                postObj["image"] = imageFile
            }
            else
            {
                postObj["hasImage"] = "NO"
            }
            
            var d = NSData(contentsOfURL: self.data.filePathUrl)
            let soundFile = PFFile(name: "sound", data: d!)
            postObj["sound"] = soundFile
            
            postObj.save()
            println("uploaded")
        
        }
    }
}


