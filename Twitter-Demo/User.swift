//
//  User.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/23/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileUrl: NSURL?
    var tagline: String?
    var backgroundUrl: NSURL?
    var userDescription: String?
    var location: String?
    var following: Int?
    var follower: Int?
    
    var dictionary: NSDictionary?
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        userDescription = dictionary["description"] as? String
        location = dictionary["location"] as? String
        follower = dictionary["followers_count"] as? Int
        following = dictionary["friends_count"] as? Int

        let profile_image_url = dictionary["profile_image_url_https"] as? String
        if let profile_image_url = profile_image_url{
            profileUrl = NSURL(string: profile_image_url)
        }
        
        let background_image_url = dictionary["profile_background_image_url_https"] as? String
        if let background_image_url = background_image_url{
            backgroundUrl = NSURL(string: background_image_url)
        }
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
        
        if _currentUser == nil{
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let userData = defaults.objectForKey("currentUserData") as? NSData
        
            if let userData = userData{
                let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
        
                _currentUser = User(dictionary: dictionary)
            }
        }
            return _currentUser
        }
        set(user){
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }else{
                defaults.setObject(nil, forKey: "currentUser")
            }
            defaults.synchronize()
        }
    }
}
