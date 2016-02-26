//
//  TweetsViewController.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/23/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var tweets: [Tweet]?
    
    @IBOutlet var tweetTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTable.dataSource = self
        tweetTable.delegate = self
        tweetTable.rowHeight = UITableViewAutomaticDimension
        tweetTable.estimatedRowHeight = 120
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tweetTable.insertSubview(refreshControl, atIndex: 0)
        
        TwitterClient.sharedInstance.homeTimeline(nil, completion: { (tweets, error) -> () in
            if tweets != nil{
                self.tweets = tweets
                self.tweetTable.reloadData()
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tweetTable.reloadData()
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
        let cell = tweetTable.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.selectionStyle = .None
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
   var isMoreDataLoading = false
    
    func loadMoreData() {
        TwitterClient.sharedInstance.homeTimeline(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.isMoreDataLoading = false
            self.tweetTable.reloadData()
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tweetTable.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetTable.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetTable.dragging) {
                print("Scrolling Called")
                isMoreDataLoading = true
                loadMoreData()
            }
            
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tweetTable.indexPathForCell(cell)
        let tweet = tweets![indexPath!.row]
        
        let tweetdetailviewcontroller = segue.destinationViewController as! TweetDetailViewController
        tweetdetailviewcontroller.tweet = tweet
    }
    

}
