//
//  SearchUserVC.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 27/04/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

class SearchUserVC: UIViewController , UITableViewDataSource , UITableViewDelegate ,UISearchBarDelegate, UISearchDisplayDelegate  {

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var resultsTable: UITableView!
    var resultsNameArray = [String?]()
    var resultsUsernameArray = [String]()
    var resultsImageFiles = [PFFile?]()
    var searchActive : Bool = false
    var filtered:[String] = []


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
    }
    override func viewDidAppear(animated: Bool) {
        searchText.delegate = self
        
        resultsTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchText: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchText: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchText: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchText: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
                resultsNameArray.removeAll(keepCapacity: false)
                resultsUsernameArray.removeAll(keepCapacity: false)
                resultsImageFiles.removeAll(keepCapacity: false)
        
                var query = PFUser.query()
        
                if searchText != ""{
                query!.whereKey("username", containsString: searchText)
        
                println(self.searchText)
                query!.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error:NSError?) -> Void in
                    if error == nil{
                        for object in objects!{
                            self.resultsNameArray.append(object.objectForKey("profileName") as? String)
                            self.resultsUsernameArray.append(object.objectForKey("username") as! String)
                            self.resultsImageFiles.append(object.objectForKey("photo") as? PFFile)
                            self.resultsTable.reloadData()
                            
                        }
                    }
                    
                })
                
                }
    }

    
//    func search(searchText: String? = nil){
//
//        resultsNameArray.removeAll(keepCapacity: false)
//        resultsUsernameArray.removeAll(keepCapacity: false)
//        resultsImageFiles.removeAll(keepCapacity: false)
//        
//        var query = PFUser.query()
//        //query!.whereKey("username", notEqualTo: PFUser.currentUser()!.username!)
//        //query!.whereKey("uesrname", equalTo: searchText!)
//        if searchText != ""{
//        query!.whereKey("username", containsString: searchText)
//
//        println(self.searchText)
//        query!.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error:NSError?) -> Void in
//            if error == nil{
//                for object in objects!{
//                    self.resultsNameArray.append(object.objectForKey("profileName") as? String)
//                    self.resultsUsernameArray.append(object.objectForKey("username") as! String)
//                    self.resultsImageFiles.append(object.objectForKey("photo") as? PFFile)
//                    self.resultsTable.reloadData()
//                    
//                }
//            }
//            
//        })
//        
//        }
//    }
//    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
//        if(searchActive) {
//            return filtered.count
//        }
        return resultsNameArray.count
 
    }
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 65
    }
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if results.count
//        tableView.hidden = false
//        else
//        tableView.hidden = true
//        
//        return results.count
//    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell:SearchUserCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SearchUserCell
        
        cell.lblProfileName.text = self.resultsNameArray[indexPath.row]
        cell.lblUsername.text = self.resultsUsernameArray[indexPath.row]
        println(resultsNameArray)
        var query = PFQuery(className: "Follow")

        query.whereKey("user", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("userToFollow", equalTo: cell.lblUsername.text!)
        
        query.countObjectsInBackgroundWithBlock {
            (count:Int32, error:NSError?) -> Void in
            
            if error == nil {
                
                if count == 0 {
                    
                    cell.btnFollow.setTitle("Follow", forState: UIControlState.Normal)
                    
                } else {
                    
                    cell.btnFollow.setTitle("Following", forState: UIControlState.Normal)
                    
                }
            }
        }
        
        self.resultsImageFiles[indexPath.row]?.getDataInBackgroundWithBlock {
            (imageData:NSData?, error:NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profilePic.image = image
                
            }
        }
        
        return cell
    }

    
    @IBAction func Cancel(sender: AnyObject)
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }


}
