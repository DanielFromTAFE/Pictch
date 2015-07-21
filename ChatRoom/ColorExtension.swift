//
//  ColorExtension.swift
//  ChatRoom
//
//  Created by WAI MING CHOI on 6/05/2015.
//  Copyright (c) 2015 WAI MING CHOI. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageWithColor(color:UIColor?) -> UIImage! {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext();
        
        if let color = color {
            
            color.setFill()
        }
        else {
            
            UIColor.whiteColor().setFill()
        }
        
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}
extension UIColor {
    
    class func colorWithHex(hexString: String?) -> UIColor? {
        
        return colorWithHex(hexString, alpha: 1.0)
    }
    
    class func colorWithHex(hexString: String?, alpha: CGFloat) -> UIColor? {
        
        if let hexString = hexString {
            
            var error : NSError? = nil
            
            let regexp = NSRegularExpression(pattern: "\\A#[0-9a-f]{6}\\z",
                options: .CaseInsensitive,
                error: &error)
            
            let count1 = regexp!.numberOfMatchesInString(hexString,
                options: .ReportProgress,
                range: NSMakeRange(0, count(hexString)))
            
            if count1 != 1 {
                
                return nil
            }
            
            var rgbValue : UInt32 = 0
            
            let scanner = NSScanner(string: hexString)
            
            scanner.scanLocation = 1
            scanner.scanHexInt(&rgbValue)
            
            let red   = CGFloat( (rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat( (rgbValue & 0xFF00) >> 8) / 255.0
            let blue  = CGFloat( (rgbValue & 0xFF) ) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        return nil
    }
    
}
