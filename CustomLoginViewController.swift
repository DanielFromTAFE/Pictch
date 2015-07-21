////
////  CustomLoginViewController.swift
////  ChatRoom
////
////  Created by WAI MING CHOI on 1/04/2015.
////  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
////
//
//import UIKit
//import ParseUI
//
//class CustomLoginViewController: UIViewController {
//    @IBOutlet weak var txtUsername: UITextField!
//    @IBOutlet weak var txtPassword: UITextField!
//    
//    var actInd:UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150))as
//        UIActivityIndicatorView
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.actInd.center = self.view.center
//        self.actInd.hidesWhenStopped = true
//        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        view.addSubview(self.actInd)
//
//        // Do any additional setup after loading the view.
//    }
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    //MARK: Actions
//    
//
//    @IBAction func btnLogin(sender: AnyObject) {
//        var username = self.txtUsername.text
//        var password = self.txtPassword.text
//        actInd.startAnimating()
//        PFUser.logInWithUsernameInBackground(username,password: password) { (user: PFUser!, error: NSError!) -> Void in
//            self.actInd.stopAnimating()
//
//            if  user != nil
//            {
//                var alert = UIAlertView(title: "Success", message: "Logged in", delegate: self, cancelButtonTitle: "OK")
//                alert.show()
//            }
//            else
//            {
//                var alert = UIAlertView(title: "Fail", message: "Error", delegate: self, cancelButtonTitle: "OK")
//                alert.show()
//            }
//        }
//
//    }
//    
//    
//    @IBAction func btnSignUp(sender: AnyObject) {
//        self.performSegueWithIdentifier("signUp", sender: nil)
//    }
//}
