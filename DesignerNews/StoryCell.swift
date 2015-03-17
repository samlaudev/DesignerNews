//
//  StoryCell.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/13/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

protocol StoryCellDelegate: class {
    func storyCellDidTouchUpvoate(cell: StoryCell, sender: AnyObject)
    func storyCellDidTouchComment(cell: StoryCell, sender: AnyObject)
}

class StoryCell: UITableViewCell {

    // MARK: - UI properties
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    
    // MARK: Delegate
    weak var delegate: StoryCellDelegate?

    // MARK: - Respond to action
    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
        upvoteButton.animate()
        delegate?.storyCellDidTouchUpvoate(self, sender: sender)
    }
    
    @IBAction func commentButtonDidTouch(sender: AnyObject) {
        commentButton.animate()
        delegate?.storyCellDidTouchComment(self, sender: self)
    }
    
    // MARK: - UI helper
    func configureStoryCell(story: JSON) {
        let title = story["title"].string ?? ""
        let badge = story["badge"].string ?? ""
        let userPortraitUrl = story["user_portrait_url"].string
        let userDisplayName = story["user_display_name"].string ?? ""
        let userJob = story["user_job"].string ?? ""
        let createdAt = story["created_at"].string ?? ""
        let voteCount = story["vote_count"].int ?? 0
        let commentCount = story["comment_count"].int ?? 0
        let comment = story["comment"].string ?? ""
        let commentHTML = story["comment_html"].string ?? ""
        
        badgeImageView.image = UIImage(named: "badge-" + badge)
        titleLabel.text = title
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, "yyyy-MM-dd'T'HH:mm:ssZ"), true)
        avatarImageView.url = userPortraitUrl?.toURL()
        avatarImageView.placeholderImage = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        upvoteButton.setTitle("\(voteCount)", forState: UIControlState.Normal)
        commentButton.setTitle("\(commentCount)", forState: UIControlState.Normal)
        if let commentTextView = commentTextView {
            commentTextView.text = comment
//            commentTextView.attributedText = htmlToAttributedString(commentHTML + "<style>*{font-family:\"Avenir Next\";font-size:16px;line-height:20px}img{max-width:300px}</style>")
        }
    }
}
