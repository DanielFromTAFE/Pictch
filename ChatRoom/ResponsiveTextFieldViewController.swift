//
//  ResponsiveTextFieldViewController.swift
//  Swift version of: VBResponsiveTextFieldViewController
//  Original code: https://github.com/ttippin84/VBResponsiveTextFieldViewController
//
//  Created by David Sandor on 9/27/14.
//  Copyright (c) 2014 David Sandor. All rights reserved.
//

import Foundation
import UIKit

class ResponsiveTextFieldViewController : UIViewController
{
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 30.0
    var keyboardFrame: CGRect = CGRect.nullRect
    var keyboardIsShowing: Bool = false
    weak var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        for subview in self.view.subviews
        {
            if (subview.isKindOfClass(UITextField))
            {
                var textField = subview as! UITextField
                textField.addTarget(self, action: "textFieldDidReturn:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
                
                textField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingDidBegin)
                
            }
        }
        
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey]as! NSValue).CGRectValue()
            self.arrangeViewOffsetFromKeyboard()
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.keyboardIsShowing = false
        
        self.returnViewToInitialFrame()
    }
    
    func arrangeViewOffsetFromKeyboard()
    {
        var theApp: UIApplication = UIApplication.sharedApplication()
        var windowView: UIView? = theApp.delegate!.window!
        
        var textFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.activeTextField!.frame.origin.y + self.activeTextField!.frame.size.height)
        
        var convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        
        var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        
        var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3.0, options: nil, animations: {
            self.view.center = adjustedViewFrameCenter
            
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
    }
    
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3.0, options: nil, animations: {
                self.view.frame = initialViewRect
                
                self.view.layoutIfNeeded()
                
                }, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if (self.activeTextField != nil)
        {
            self.activeTextField?.resignFirstResponder()
            self.activeTextField = nil
            
        }
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.activeTextField = textField
        
        if(self.keyboardIsShowing)
        {
            self.arrangeViewOffsetFromKeyboard()
        }
    }
}