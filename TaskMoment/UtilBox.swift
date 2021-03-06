//
//  UtilBox.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/14.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import UIKit
import Photos

class UtilBox {
    // 验证是否为手机号
    static func isTelephoneNum(input: String) -> Bool {
        let regex:NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: "^[1][35789][0-9]{9}$", options: NSRegularExpressionOptions.CaseInsensitive)
            
            let  matches = regex.matchesInString(input, options: NSMatchingOptions.ReportCompletion , range: NSMakeRange(0, input.characters.count))
            
            if matches.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    // 字符串转Dic
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    // 设置图片阴影
    static func setShadow(imageView: UIImageView, opacity: Float) {
        imageView.layer.shadowOpacity = opacity
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    // 清除用户数据
    static func clearUserDefaults() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Cookie)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Nickname)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Portrait)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Mid)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Cid)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.CompanyName)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.CompanyCreator)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.CompanyBackground)
        userDefaults.removeObjectForKey(Constants.UserDefaultKey.Time)
    }
    
    // 时间戳转字符串
    static func getDateFromString(date: String, format: String) -> String {
        let outputFormat = NSDateFormatter()
        // 格式化规则
        outputFormat.dateFormat = format
        // 定义时区
        outputFormat.locale = NSLocale(localeIdentifier: "shanghai")
        // 发布时间
        let pubTime = NSDate(timeIntervalSince1970: Double(date)!)
        return outputFormat.stringFromDate(pubTime)
    }
    
    // 字符串转时间戳
    static func stringToDate(date: String, format: String) -> NSTimeInterval {
        
        let outputFormatter = NSDateFormatter()
        
        outputFormatter.dateFormat = format
        
        return outputFormatter.dateFromString(date)!.timeIntervalSince1970
    }
    
    // 压缩图片
    static func compressImage(image: UIImage!, maxSize: Int) -> NSData {
        var compression: CGFloat = 1.0
        let maxCompression: CGFloat = 0.1
        
        var imageData = UIImageJPEGRepresentation(image, compression)
        
        while (imageData?.length > maxSize && compression > maxCompression) {
            compression -= 0.1
            imageData = UIImageJPEGRepresentation(image, compression)
        }
        
        return imageData!
    }
    
    // MD5加密
    static func MD5(string: String) -> String {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)!
        let c_data = data.bytes
        var md: [UInt8] = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        CC_MD5(c_data, CC_LONG(data.length), UnsafeMutablePointer<UInt8>(md))
        
        var ret: String = ""
        for index in 0 ..< Int(CC_MD5_DIGEST_LENGTH) {
            ret += String(format: "%.2X", md[index])
        }
        return ret
    }
    
    // PHAsset转UIImage
    static func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    // 弹出提示对话框
    static func alert(vc: UIViewController, message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
}
