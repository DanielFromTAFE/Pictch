//
//  ProfileVC.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 27/05/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var ProfileIcon: UIImageView!
    
    var userArray = [String]()
    var resultsNameArray = [String]()
    var resultsIcon = [PFFile]()
    var resultsSoundArray = [PFFile]()
    var resultsHasImageArray = [String?]()
    var resultsImgArray = [PFFile?]()
    var likeArray = [String?]()
    var resultsTimeTampArray = [NSDate?]()
    var audioPlayer:AVAudioPlayer!
    var username: String = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ProfileIcon.layer.cornerRadius = 5.0
        ProfileIcon.layer.cornerRadius = ProfileIcon.frame.size.width/2
        ProfileIcon.clipsToBounds = true
        label.text = username
        println(username)
        self.refreshTeble()
        self.navigationController!.setNavigationBarHidden(false, animated:true)

    }

    func refreshTeble()
    {
        
        resultsNameArray.removeAll(keepCapacity: false)
        resultsIcon.removeAll(keepCapacity: false)
        resultsSoundArray.removeAll(keepCapacity: false)
        resultsHasImageArray.removeAll(keepCapacity: false)
        resultsImgArray.removeAll(keepCapacity: false)
        resultsTimeTampArray.removeAll(keepCapacity: false)
        likeArray.removeAll(keepCapacity: false)
                
        var findUserQuery = PFQuery(className: "Post")
        if username != ""
        {
            findUserQuery.whereKey("userName", equalTo: username)

        }
        else
        {
            findUserQuery.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
        }

        findUserQuery.addDescendingOrder("createdAt")
        
        findUserQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil
            {

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    findUserQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil
                        {
                            
                            for object in objects!
                            {
                                
                                self.resultsNameArray.append(object.objectForKey("profileName") as! String)
                                self.resultsIcon.append(object.objectForKey("icon") as! PFFile)
                                self.resultsSoundArray.append(object.objectForKey("sound") as! PFFile)
                                self.resultsHasImageArray.append(object.objectForKey("hasImage") as? String)
                                self.resultsImgArray.append(object.objectForKey("image") as? PFFile)
                                self.likeArray.append(object.objectForKey("likeCount") as? String)
                                self.resultsTimeTampArray.append(object.createdAt)
                                
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.resultTable.reloadData()
                            })

                            
                        }
                    }
                    
                })
            }
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return resultsNameArray.count
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 326
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:ProfileCell = tableView.dequeueReusableCellWithIdentifier("profileCell") as! ProfileCell
        
        cell.like.tag = indexPath.row
        cell.like.addTarget(self, action: "like:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.profileName.text = self.resultsNameArray[indexPath.row]
        cell.count.text = self.likeArray[indexPath.row]
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        var todaysDate:NSDate = NSDate()
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        
        let startDate = dateFormatter.stringFromDate(self.resultsTimeTampArray[indexPath.row]!)
        let strStart = dateFormatter.dateFromString(startDate)
        let endDate = dateFormatter.dateFromString(DateInFormat)
        
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .CalendarUnitHour | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitMinute
        let components = cal.components(unit, fromDate: strStart!, toDate: endDate!, options: nil)
        
        if components.day < 1
        {
            println("1")
            cell.Time.text = "\(components.hour)" + " " + "hours" + " " + "ago"
            if components.hour < 24
            {
                println("min")
                cell.Time.text = "\(components.minute)" + " " + "minute" + " " + "ago"
                
            }
            
        }
            
        else
        {
            cell.Time.text = "\(components.day)" + " " + "days" + " " + "ago"
            
        }

        
        resultsIcon[indexPath.row].getDataInBackgroundWithBlock { (imageData:
            NSData?, error:NSError?) -> Void in
            if error == nil{
                let image = UIImage(data:imageData!)
                cell.userImg.image = image
                self.ProfileIcon.image = image

            }
        }
        if resultsHasImageArray[indexPath.row] == "YES" {
            
            cell.postImage.hidden = false
            
            resultsImgArray[indexPath.row]?.getDataInBackgroundWithBlock({
                (imageData:NSData?, error:NSError?) -> Void in
                
                if error == nil {
                    
                    let image = UIImage(data: imageData!)
                    cell.postImage.image = image
                }
                else
                {
                    
                    var alert = UIAlertController(title: "Error", message: "Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            })
            
        }
        resultsSoundArray[indexPath.row].getDataInBackgroundWithBlock { (soundData:NSData?, error:NSError?) -> Void in
            
            if error == nil
            {
                
                self.audioPlayer = AVAudioPlayer(data: soundData, error: nil)
                
            }
            else
            {

                var alert = UIAlertController(title: "Error", message: "Please try again later", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        }
        
        return cell
    }

    @IBAction func PlaySound(sender: AnyObject)
    {
        
        self.audioPlayer.stop()
        self.audioPlayer.play()
        
    }
    @IBAction func Back(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
