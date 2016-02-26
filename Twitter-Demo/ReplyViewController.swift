//
//  ReplyViewController.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/26/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var tweet_field: UITextField!
    
    var user: User?
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            self.user = user
            self.profile_image.setImageWithURL(user.profileUrl!)
            self.username.text = user.name
            self.screenname.text = "@\(user.screenname!)"
            }) { (error: NSError) -> () in
            print("Error fetching the user")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func post_tweet(sender: AnyObject) {
        let address = "@\(tweet!.user!.screenname!) \(self.tweet_field.text!)"
        let escapedAddress = address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        TwitterClient.sharedInstance.reply(["tweet": escapedAddress!, "id": tweet!.id!]) { (tweet, error) -> () in
        print("Tweeted")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
