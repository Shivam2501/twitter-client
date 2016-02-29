//
//  TweetDetailViewController.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/26/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var tweettext: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var retweet_count: UILabel!
    @IBOutlet weak var favorites_count: UILabel!
    @IBOutlet weak var retweet_image: UIButton!
    @IBOutlet weak var favorite_image: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var tweet: Tweet!
    var count_retweet: Int = 0
    var count_favorite: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.title = " "
        
        profileImage.setImageWithURL((tweet.user?.profileUrl)!)
        username.text = tweet.user?.name
        screenname.text = "@\(tweet.user!.screenname!)"
        tweettext.text = tweet.text
        
        count_favorite = tweet.favourites_count
        count_retweet = tweet.retweet_count
        retweet_count.text = "\(tweet.retweet_count)"
        favorites_count.text = "\(tweet.favourites_count)"
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = .ShortStyle
        
        let dateString = dateformatter.stringFromDate(tweet.timestamp!)
        timestamp.text = dateString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetClicked(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(["id": tweet.id!]) { (tweets, error) -> () in
            if (tweets != nil){
                self.retweet_count.text = "\(self.count_retweet+1)"
                self.retweet_image.setImage(UIImage(named: "retweet-action-on-pressed"), forState: UIControlState.Normal)
            }
        }

    }
    
    @IBAction func favoriteClicked(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(["id": tweet.id!]) { (tweet, error) -> () in
            
            if (tweet != nil) {
                self.favorite_image.setImage(UIImage(named: "like-action-on-pressed"), forState: UIControlState.Normal)
                self.favorites_count.text = "\(self.count_favorite+1)"
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let replyviewcontroller = segue.destinationViewController as! ReplyViewController
        replyviewcontroller.tweet = self.tweet
    }
    

}
