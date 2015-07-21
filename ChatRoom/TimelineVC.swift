//
//  TimelineVC.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 28/04/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class TimelineVC: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var resultsTable: UITableView!
    
    var followArray = [String]()
    var resultsUsernameArray = [String]()
    var resultsNameArray = [String]()
    var resultsIcon = [PFFile]()
    var resultsSoundArray = [PFFile]()
    var resultsHasImageArray = [String?]()
    var resultsImgArray = [PFFile?]()
    var resultsTimeTampArray = [NSDate?]()
    var likeArray = [String?]()
    var allObjectArray: NSMutableArray = []
    var refresher:UIRefreshControl!
    var audioPlayer:AVAudioPlayer!
    var filePathUrl: NSURL!
    var selectedUser = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        for var i = 0; i <= 500; i++ {
            allObjectArray.addObject(i)
        }

        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.blackColor()
        refresher.layer.position = CGPointMake(0, 0)
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.resultsTable.addSubview(refresher)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    func refresh()
    {

        self.refreshResult()
        
    }
    
    func refreshResult()
    {
        resultsUsernameArray.removeAll(keepCapacity: false)
        followArray.removeAll(keepCapacity: false)
        resultsNameArray.removeAll(keepCapacity: false)
        resultsIcon.removeAll(keepCapacity: false)
        resultsSoundArray.removeAll(keepCapacity: false)
        resultsHasImageArray.removeAll(keepCapacity: false)
        resultsImgArray.removeAll(keepCapacity: false)
        likeArray.removeAll(keepCapacity: false)
        resultsTimeTampArray.removeAll(keepCapacity: false)
        
        var followQuery = PFQuery(className: "Follow")
        followQuery.whereKey("user", equalTo: PFUser.currentUser()!.username!)
        
        followQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil
            {
                for object in objects!
                {
                    
                    self.followArray.append(object.objectForKey("userToFollow") as! String)
                    
                }
                var query = PFQuery(className: "Post")
                query.whereKey("userName", containedIn: self.followArray)
            
                query.addDescendingOrder("createdAt")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil
                        {
                            for object in objects!
                            {
                             self.resultsUsernameArray.append(object.objectForKey("userName") as! String)
                                self.resultsNameArray.append(object.objectForKey("profileName") as! String)
                                self.resultsIcon.append(object.objectForKey("icon") as! PFFile)
                                self.resultsSoundArray.append(object.objectForKey("sound") as! PFFile)
                                self.resultsHasImageArray.append(object.objectForKey("hasImage") as? String)
                                self.resultsImgArray.append(object.objectForKey("image") as? PFFile)
                                self.likeArray.append(object.objectForKey("likeCount") as? String)
                                self.resultsTimeTampArray.append(object.createdAt)
                                
                            }
            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.resultsTable.reloadData()
                                self.refresher.endRefreshing()
                                
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
    }

    override func viewDidAppear(animated: Bool)
    {
        self.refreshResult()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return resultsNameArray.count
        
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return 326
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell:TimelineCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TimelineCell
        
        cell.like.tag = indexPath.row
        cell.like.addTarget(self, action: "like:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.lblUsername.text = resultsUsernameArray[indexPath.row]
        self.selectedUser = resultsUsernameArray[indexPath.row]
        println(selectedUser)
        
        cell.profileName.setTitle(self.resultsNameArray[indexPath.row], forState: UIControlState.Normal)
        cell.Img.hidden = true
        cell.count.text = self.likeArray[indexPath.row]
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"

        var todaysDate:NSDate = NSDate()
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        
        let startDate = dateFormatter.stringFromDate(resultsTimeTampArray[indexPath.row]!)
        let strStart = dateFormatter.dateFromString(startDate)
        let endDate = dateFormatter.dateFromString(DateInFormat)
                
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .CalendarUnitHour | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitMinute
        let components = cal.components(unit, fromDate: strStart!, toDate: endDate!, options: nil)

        
        if components.day < 1
        {
            cell.Time.text = "\(components.hour)" + " " + "hours" + " " + "ago"
            if components.hour < 24
            {
                cell.Time.text = "\(components.minute)" + " " + "minute" + " " + "ago"

            }

        }

        else
        {
            cell.Time.text = "\(components.day)" + " " + "days" + " " + "ago"

        }

        resultsIcon[indexPath.row].getDataInBackgroundWithBlock { (imageData:
            NSData?, error:NSError?) -> Void in
            if error == nil
            {
                let image = UIImage(data:imageData!)
                cell.profilePic.image = image
            }
        }
        if resultsHasImageArray[indexPath.row] == "YES" {
            
            cell.Img.hidden = false
            
            resultsImgArray[indexPath.row]?.getDataInBackgroundWithBlock({
                (imageData:NSData?, error:NSError?) -> Void in
                
                if error == nil
                {
                    
                    let image = UIImage(data: imageData!)
                    cell.Img.image = image
                    
                }else
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
    
    @IBAction func playSound(sender: AnyObject)
    {
        var cell:TimelineCell =  TimelineCell()

        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
        
    }
    
    @IBAction func btnStop(sender: AnyObject) {
        var cell:TimelineCell = TimelineCell()
        cell.btnStop.hidden = true
        cell.btnPlay.hidden = false
    }
    
    @IBAction func like(sender: UIButton)
    {
        println("1")
        var button = sender
        var postLike =  PFObject(className:"Post")
        var query = PFQuery(className: "Post")
        query.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            
            var liked = !button.selected
            println("2")
            
            //get current number of likes on post
            if var likeCounter = postLike["likeCount"] as? Int
            {
                println("3")
                
                let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
                
                //update likeCount
                if liked {
                    likeCounter = likeCounter + 1
                    println(likeCounter)
                    
                    
                }else {
                    likeCounter = likeCounter - 1
                    println(likeCounter)
                    
                }
                println("4")
                
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "GoToProfilePage"
        {
            
            let navVC = segue.destinationViewController as! UINavigationController
            
            let ProfilePage = navVC.viewControllers.first as! ProfileVC
            ProfilePage.username = self.selectedUser
        }
    }
 
}
