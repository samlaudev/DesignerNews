//
//  DesignerNewsService.swift
//  DesignerNews
//
//  Created by Sam Lau on 3/17/15.
//  Copyright (c) 2015 Sam Lau. All rights reserved.
//

import Alamofire

// MARK: - Resource URL path
enum ResourcePath: Printable {
    case Login
    case Stories
    case StoryId(storyId: Int)
    case StoryUpvote(storyId: Int)
    case StoryReply(storyId: Int)
    case CommentUpvote(commentId: Int)
    case CommentReply(commentId: Int)
    
    var description: String {
        
        switch self {
        case .Login:  return DesignerNewsService.baseURL + "/oauth/token"
        case .Stories:  return DesignerNewsService.baseURL + "/api/v1/stories"
        case .StoryId(let id): return DesignerNewsService.baseURL + "/api/v1/stories/\(id)"
        case .StoryUpvote(let id): return DesignerNewsService.baseURL + "/api/v1/stories/\(id)/upvote"
        case .StoryReply(let id): return DesignerNewsService.baseURL + "/api/v1/stories/\(id)/reply"
        case .CommentUpvote(let id): return DesignerNewsService.baseURL + "/api/v1/comments/\(id)/upvote"
        case .CommentReply(let id): return DesignerNewsService.baseURL + "/api/v1/comments/\(id)/reply"
            
        default:  return ""
        }
    }
}

struct DesignerNewsService {
    // MARK: - Base constants
    private static let baseURL = "https://api-news.layervault.com"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"
    
    // MARK: - Retrieve story information
    static func storiesForSection(section: String, page: Int, response: (JSON)->()) {
        let parameters = [
            "page": "\(page)",
            "client_id":clientID,
        ]
        Alamofire.request(.GET, ResourcePath.Stories.description + "/" + section, parameters:parameters).responseJSON { (request, _, data, _) -> Void in
            let stories = JSON(data ?? [])
            response(stories["stories"])
        }
    }
    
    static func storyForId(storyId: Int, response:(JSON)->()) {
        let parameters = [
            "client_id":clientID
        ]
        
        Alamofire.request(.GET, ResourcePath.StoryId(storyId: storyId).description, parameters: parameters).responseJSON { (_, _, data, _) -> Void in
            let jsonData = JSON(data ?? [])
            let story = jsonData["story"]
            response(story)
        }
    }
    
    // MARK: - Login
    static func loginWithEmail(email: String, password: String, response: (token: String?)->()) {
        let parameters = [
            "grant_type": "password",
            "username": email,
            "password": password,
            "client_id": clientID,
            "client_secret": clientSecret,
        ]
        
        Alamofire.request(.POST, ResourcePath.Login.description, parameters: parameters)
          .responseJSON { (request, _, data, _) -> Void in
            let token = JSON(data ?? "")["access_token"].string
            response(token: token)
        }
    }
    
    // MARK: - Upvote
    static func upvoteStoryWithId(storyId: Int, token:String, response:(successful: Bool)->()) {
        upvoteWithURLString(ResourcePath.StoryUpvote(storyId: storyId).description, token: token, response: response)
    }

    static func upvoteCommentWithId(commentId: Int, token:String, response:(successful: Bool)->()) {
        upvoteWithURLString(ResourcePath.CommentUpvote(commentId: commentId).description, token: token, response: response)
    }
    
    private static func upvoteWithURLString(urlString: String, token: String, response:(successful: Bool)->()) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        Alamofire.request(request).responseJSON { (_, urlResponse, _, _) -> Void in
            let successful = urlResponse?.statusCode == 200
            response(successful: successful)
        }
    }
    
    // MARK: - Reply
    static func replyStoryWithId(storyId: Int, token: String, body: String, response: (successful: Bool)->()) {
        replyWithURLString(ResourcePath.StoryReply(storyId: storyId).description, token: token, body: body, response: response)
    }
    
    static func replyCommentWithId(commentId: Int, token: String, body: String, response: (successful: Bool)->()) {
        replyWithURLString(ResourcePath.CommentReply(commentId: commentId).description, token: token, body: body, response: response)
    }
    
    private static func replyWithURLString(urlString: String, token: String, body: String, response: (successsful: Bool)->()) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.HTTPBody = "comment[body]=\(body)".dataUsingEncoding(NSUTF8StringEncoding)
        Alamofire.request(request).responseJSON { (_, _, data, _) -> Void in
            let jsonData = JSON(data!)
            if let comment = jsonData["comment"].string {
                response(successsful: true)
            }else {
                response(successsful: false)
            }
            
        }
    }
}
