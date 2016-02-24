//
//  Tweet.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/23/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweet_count: Int = 0
    var favourites_count: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweet_count = (dictionary["retweet_count"] as? Int) ?? 0
        favourites_count = (dictionary["favourties_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm::ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}