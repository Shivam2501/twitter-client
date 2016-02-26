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
    @IBOutlet weak var retweet_count: UILabel!
    @IBOutlet weak var favourite_count: UILabel!
    
    @IBOutlet weak var retweet_image: UIButton!
    @IBOutlet weak var favourite_image: UIButton!
    var count_retweet: Int?
    var count_favourite: Int?
    
    var tweet: Tweet!{
        didSet{
            tweet_message.text = tweet.text
            username.text = tweet.user?.name
            profileImage.setImageWithURL((tweet.user?.profileUrl)!)
            time.text = calculateTime(tweet.timestamp!.timeIntervalSinceNow)
            retweet_count.text = "\(tweet.retweet_count)"
            favourite_count.text =  "\(tweet.favourites_count)"
            
            count_retweet = tweet.retweet_count
            count_favourite = tweet.favourites_count
        }
    }
    
    func calculateTime(spent: NSTimeInterval) -> String {
        let Time = Int(spent) * (-1)
        var Ago: Int = 0
        var Char = ""
        
        if (Time <= 60) {
            Ago = Time
            Char = "s"
        } else if ((Time/60) <= 60) {
            Ago = Time/60
            Char = "m"
        } else if (Time/60/60 <= 24) {
            Ago = Time/60/60
            Char = "h"
        } else if (Time/60/60/24 <= 365) {
            Ago = Time/60/60/24
            Char = "d"
        } else if (Time/(3153600) <= 1) {
            Ago = Time/60/60/24/365
            Char = "y"
        }
        
        return "\(Ago)\(Char)"
    }
    
    @IBAction func retweetAction(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(["id": tweet.id!]) { (tweets, error) -> () in
            if (tweets != nil){
                self.retweet_count.text = "\(self.count_retweet!+1)"
                self.retweet_image.setImage(UIImage(named: "retweet-action-on-pressed"), forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func favouriteAction(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(["id": tweet.id!]) { (tweet, error) -> () in
            
            if (tweet != nil) {
                self.favourite_image.setImage(UIImage(named: "like-action-on-pressed"), forState: UIControlState.Normal)
                self.favourite_count.text = "\(self.count_favourite!+1)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        
        username.preferredMaxLayoutWidth = username.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        username.preferredMaxLayoutWidth = username.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
