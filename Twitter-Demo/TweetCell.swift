//
//  TweetCell.swift
//  Twitter-Demo
//
//  Created by Shivam Bharuka on 2/23/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var tweet_message: UILabel!
    
    var tweet: [Tweet]!{
        didSet{
            
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
