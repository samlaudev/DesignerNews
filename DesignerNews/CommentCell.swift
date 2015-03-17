//
//  CommentCell.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/16/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    // MARK: - UI properties
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
   
    // MARK: - Respond to action
    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
    }
    
    @IBAction func replyButtonDidTouch(sender: AnyObject) {
    }
    
    // MARK: - UI properties
    func configureCommentCell(comment: JSON) {
        let userPortraitUrl = comment["user_portrait_url"].string
        let userDisplayName = comment["user_display_name"].string ?? ""
        let userJob = comment["user_job"].string ?? ""
        let createdAt = comment["created_at"].string ?? ""
        let voteCount = comment["vote_count"].int ?? 0
        let body = comment["body"].string ?? ""
        let bodyHTML = comment["body_html"].string ?? ""
        
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, "yyyy-MM-dd'T'HH:mm:ssZ"), true)
        avatarImageView.url = userPortraitUrl?.toURL()
        avatarImageView.placeholderImage = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        upvoteButton.setTitle("\(voteCount)", forState: UIControlState.Normal)
        commentTextView.text = body
//        commentTextView.attributedText = htmlToAttributedString(bodyHTML + "<style>*{font-family:\"Avenir Next\";font-size:16px;line-height:20px}img{max-width:300px}</style>")
    }
}
