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
        case .StoryReply(let id): return DesignerNewsService.baseURL + "/api/v1/stories/\(id )/reply"
        case .CommentUpvote(let id): return DesignerNewsService.baseURL + "/api/v1/comments/\(id)/upvote"
        case .CommentReply(let id): return DesignerNewsService.baseURL + "/api/v1/comments/\(id)/reply"
            
        default:    return ""
        }
    }
}

struct DesignerNewsService {
    // MARK: - Base constants
    private static let baseURL = "https://api-news.layervault.com"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"
    
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
}
