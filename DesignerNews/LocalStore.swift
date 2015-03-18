//
//  LocalStore.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/17/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import UIKit

struct LocalStore {
    // MARK: - Properties
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    static let tokenKey = "tokenKey"
    
    // Mark: - Handle stored token
    static func saveToken(token: String) {
        userDefaults.setValue(token, forKey: tokenKey)
    }
    
    static func getToken() -> String? {
        return userDefaults.stringForKey(tokenKey)
    }
    
    static func removeToken() {
        userDefaults.removeObjectForKey(tokenKey)
    }
    
    // MARK: - Handle store upvote
    static func saveUpvoteStory(storyId: Int) {
        appendId(storyId, key: "upvoteStoriesKey")
    }
    
    static func saveUpvoteComment(commentId: Int) {
        appendId(commentId, key: "upvoteCommentsKey")
    }
    
    private static func appendId(id: Int, key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        
        if !contains(elements, id) {
            userDefaults.setObject(elements + [id], forKey: key)
        }
    }
    
    static func isStoryUpvoted(storyId: Int) -> Bool {
        return isContainsUpvoteId(storyId, forKey: "upvoteStoriesKey")
    }
    
    static func isCommentUpvoted(commentId: Int) -> Bool {
        return isContainsUpvoteId(commentId, forKey: "upvoteCommentsKey")
    }
    
    private static func isContainsUpvoteId(id: Int, forKey key:String) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        return contains(elements, id)
    }
    
    // Business methods
    static func isHasLogin() -> Bool {
        return getToken() != nil ? true : false
    }
}
