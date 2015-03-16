//
//  CommentsViewController.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/16/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {

    // MARK: - UI properties
    var story: JSON!
    var comments: JSON!
    
    // MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dynamic height for cells
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
        if let storyCell = cell as? StoryCell {
            storyCell.configureStoryCell(story)
        }else if let commentCell = cell as? CommentCell {
            commentCell.configureCommentCell(comments[indexPath.row - 1])
        }
        
        return cell
    }
}
