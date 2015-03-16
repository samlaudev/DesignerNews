//
//  StoryCell.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/13/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit
import Spring

protocol StoryCellDelegate: class {
    func storyCellDidTouchUpvoate(cell: StoryCell, sender: AnyObject)
    func storyCellDidTouchComment(cell: StoryCell, sender: AnyObject)
}

class StoryCell: UITableViewCell {

    // MARK: - UI properties
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
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
        delegate?.storyCellDidTouchComment(self, sender: sender)
    }
    
    // MARK: - UI helper
    func configureStoryCell(story: AnyObject) {
        let title = story["title"] as String
        let badge = story["badge"] as String
        let userPortraitUrl = story["user_portrait_url"] as String
        let userDisplayName = story["user_display_name"] as String
        let userJob = story["user_job"] as String
        let createdAt = story["created_at"] as String
        let voteCount = story["vote_count"] as Int
        let commentCount = story["comment_count"] as Int
        let comment = story["comment"] as String
        
        badgeImageView.image = UIImage(named: "badge-" + badge)
        titleLabel.text = title
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, "yyyy-MM-dd'T'HH:mm:ssZ"), true)
        avatarImageView.image = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        upvoteButton.setTitle("\(voteCount)", forState: UIControlState.Normal)
        commentButton.setTitle("\(commentCount)", forState: UIControlState.Normal)
        if let commentTextView = commentTextView {
            commentTextView.text = comment
        }
    }
}
