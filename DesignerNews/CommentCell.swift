//
//  CommentCell.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/16/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

protocol CommonCellDelegate: class {
    func commonCellDelegateDidTouchUpvote(cell: CommentCell)
    func commonCellDelegateDidTouchComment(cell: CommentCell)
}

class CommentCell: UITableViewCell {
    
    // MARK: - UI properties
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    @IBOutlet weak var avatarLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var indentView: UIView!
    
    // MARK: - Delegate
    weak var delegate: CommonCellDelegate?
   
    // MARK: - Respond to action
    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
        upvoteButton.animate()
        delegate?.commonCellDelegateDidTouchUpvote(self)
    }
    
    @IBAction func replyButtonDidTouch(sender: AnyObject) {
        replyButton.animate()
        delegate?.commonCellDelegateDidTouchComment(self)
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
        
        
        let commentId = comment["id"].int!
        if LocalStore.isCommentUpvoted(commentId) {
            upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
            upvoteButton.setTitle(String(comment["vote_count"].int! + 1), forState: UIControlState.Normal)
        }else {
            upvoteButton.setImage(UIImage(named: "icon-upvote"), forState: UIControlState.Normal)
            upvoteButton.setTitle(String(comment["vote_count"].int!), forState: UIControlState.Normal)
        }
        
        let depth = comment["depth"].int! > 4 ? 4 : comment["depth"].int!
        if depth > 0 {
            avatarLeftConstraint.constant = CGFloat(depth) * 15 + 25
            separatorInset = UIEdgeInsets(top: 0, left: CGFloat(depth) * 20 + 15, bottom: 0, right: 0)
            indentView.hidden = false
        } else {
            avatarLeftConstraint.constant = 7
            separatorInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
            indentView.hidden = true
        }
        
    }
}
