//
//  TweetCell.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/23/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var tweet_message: UILabel!
    
    var tweet: Tweet!{
        didSet{
            tweet_message.text = tweet.text
            username.text = tweet.user?.name
            profileImage.setImageWithURL((tweet.user?.profileUrl)!)
            time.text = calculateTime(tweet.timestamp!.timeIntervalSinceNow)
        }
    }
    
    func calculateTime(spent: NSTimeInterval) -> String {
        var rawTime = Int(spent)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        if (rawTime <= 60) {
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) {
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) {
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) {
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) {
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
