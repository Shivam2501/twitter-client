//
//  TwitterClient.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/23/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "OFjgPhvR81GVuyu0r9JyCSgMR", consumerSecret: "Seef1D3R24oKl4TsG3iHdMYevrnMPgcvtptnTggOix8xdDYDgU")
    
    var loginSuccess: (()->())?
    var loginfailure: ((NSError)->())?
    
    
    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginfailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth"), scope: nil, success: {
            (requestToken: BDBOAuth1Credential!) -> Void in
            print("Request Token Received")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                print("Error: \(error.localizedDescription)")
                self.loginfailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success:{
            (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                 self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginfailure?(error)
            })
            
            }){ (error: NSError!) -> Void in
                self.loginfailure?(error)
        }
    }
    
    func logout(){
        deauthorize()
        User.currentUser = nil
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> () ){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let userDictionary = response as? NSDictionary
            
                let user = User(dictionary: userDictionary!)
            
                success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
               failure(error)
        })
    }
    
    func homeTimeline(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let dictionaries = response as! [NSDictionary]
            
                let tweets = Tweet.tweetsWithArray(dictionaries)
                completion(tweets: tweets, error: nil)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweets: nil, error: error)
        })
    }
    
    func retweet(params: NSDictionary?, completion: (tweets: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(params!["id"] as! Int).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            completion(tweets: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweets: nil, error: error)
        }
    }
    
    func favorite(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            var tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        }
    }
}
