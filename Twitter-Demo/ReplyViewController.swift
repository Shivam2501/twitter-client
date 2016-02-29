//
//  ReplyViewController.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/26/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var tweet_field: UITextField!
    @IBOutlet weak var word_count: UIBarButtonItem!
    
    var user: User?
    var tweet: Tweet?
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweet_field.delegate = self
        tweet_field.becomeFirstResponder()
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            self.user = user
            self.profile_image.setImageWithURL(user.profileUrl!)
            self.username.text = user.name
            self.screenname.text = "@\(user.screenname!)"
            
            if self.tweet != nil{
                self.tweet_field.text = "@\(self.tweet!.user!.screenname!)"
                self.count = 140 - self.tweet_field.text!.characters.count
                self.word_count.title = "\(self.count)"
            }
            
            }) { (error: NSError) -> () in
            print("Error fetching the user")
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.count = 140 - self.tweet_field.text!.characters.count
        self.word_count.title = "\(self.count)"
        return true
    }
    
    @IBAction func post_tweet(sender: AnyObject) {
        tweet_field.resignFirstResponder()
        let address = "\(self.tweet_field.text!)"
        let escapedAddress = address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        if self.tweet != nil{
            TwitterClient.sharedInstance.reply(["tweet": escapedAddress!, "id": tweet!.id!]) { (tweet, error) -> () in
                print("Tweeted")
            }
        }else{
            TwitterClient.sharedInstance.create(["tweet": escapedAddress!]) { (tweet, error) -> () in
                print("Tweeted")
            }
        }
        let alert = UIAlertController(title: "Tweet", message: "Message Successfully Tweeted", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.backtohome()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
       
    }
    func backtohome(){
         navigationController?.popViewControllerAnimated(true)
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
