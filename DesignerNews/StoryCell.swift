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
}
