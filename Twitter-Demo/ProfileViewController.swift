//
//  ProfileViewController.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/28/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var descriptionUser: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var tweetsTable: UITableView!
    
    var tweets: [Tweet]?
    var curr_user: User?
    var tweet: Tweet?{
        didSet{
            curr_user?.name = tweet!.user!.name!
            curr_user?.screenname = "@\(tweet!.user!.screenname!)"
            curr_user?.userDescription = tweet!.user!.userDescription!
            curr_user?.location = tweet!.user!.location!
            curr_user?.follower = tweet!.user!.follower!
            curr_user?.following = tweet!.user!.following!
            
            curr_user?.backgroundUrl = tweet!.user!.backgroundUrl!
            
            curr_user?.profileUrl = tweet!.user!.profileUrl!

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTable.dataSource = self
        tweetsTable.delegate = self
        
        tweetsTable.rowHeight = UITableViewAutomaticDimension
        tweetsTable.estimatedRowHeight = 120
   
        if (tweet == nil){
         TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            
            self.backgroundImage.setImageWithURL(user.backgroundUrl!)
            
            self.profileImage.setImageWithURL(user.profileUrl!)
            self.profileImage.layer.cornerRadius = 3
            self.profileImage.clipsToBounds = true
            self.profileImage.layer.frame = CGRectInset(self.profileImage.layer.frame, 20, 20)
            self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
            self.profileImage.layer.borderWidth = 3.0
            
            self.username.text = user.name
            self.screenname.text = "@\(user.screenname!)"
            self.descriptionUser.text = user.userDescription
            self.location.text = user.location
            self.followers.text = "\(user.follower!)"
            self.following.text = "\(user.following!)"
            
            TwitterClient.sharedInstance.userTimeline(["screenname": self.screenname.text!], completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tweetsTable.reloadData()
            })
        
            }) { (error: NSError) -> () in
                print("Error fetching the user: \(error)")
            }
        }else{
      
            self.backgroundImage.setImageWithURL((tweet?.user!.backgroundUrl!)!)
            
            self.profileImage.setImageWithURL((tweet?.user!.profileUrl!)!)
            self.profileImage.layer.cornerRadius = 3
            self.profileImage.clipsToBounds = true
            self.profileImage.layer.frame = CGRectInset(self.profileImage.layer.frame, 20, 20)
            self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
            self.profileImage.layer.borderWidth = 3.0
            
            self.username.text = (tweet?.user!.name!)!
            self.screenname.text = "@\((tweet?.user!.screenname!)!)"
            self.descriptionUser.text = (tweet?.user!.userDescription!)!
            self.location.text = (tweet?.user!.location!)!
            self.followers.text = "\((tweet?.user!.follower!)!)"
            self.following.text = "\((tweet?.user!.following!)!)"
            
            TwitterClient.sharedInstance.userTimeline(["screenname": self.screenname.text!], completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tweetsTable.reloadData()
            })

        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tweetsTable.insertSubview(refreshControl, atIndex: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        TwitterClient.sharedInstance.userTimeline(["screenname": self.screenname.text!], completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tweetsTable.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil{
            return tweets!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetsTable.dequeueReusableCellWithIdentifier("UserTweetCell", forIndexPath: indexPath) as! UserTweetTableViewCell
        cell.selectionStyle = .None
        cell.tweet = tweets![indexPath.row]
        return cell
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
