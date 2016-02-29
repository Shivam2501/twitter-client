//
//  UserTweetTableViewCell.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/28/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class UserTweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernme: UILabel!
    @IBOutlet weak var namescreen: UILabel!
    @IBOutlet weak var tweet_text: UILabel!
    
    var tweet: Tweet!{
        didSet{
            self.profileImage.setImageWithURL((tweet.user?.profileUrl)!)
            self.profileImage.layer.cornerRadius = 3
            self.profileImage.clipsToBounds = true
            
            self.usernme.text = tweet.user?.name
            self.namescreen.text = "@\(tweet.user!.screenname!)"
            self.tweet_text.text = tweet.text
        }
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
