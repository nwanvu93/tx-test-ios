//
//  GitHubUserAPI.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import Alamofire
import ObjectMapper

enum GitHubUserAPI {
    
    struct FetchUsers: Requestable {
        
        typealias Output = [User]?
        
        var httpMethod: HTTPMethod { return .get }
        
        var endpoint: String { return "/users" }
        
        var pageSize: Int
        var since: Int
        
        var params: Parameters {
            return [
                "per_page": pageSize,
                "since": since,
            ]
        }
        
        func decode(data: Any) -> Output {
            return Mapper<User>().mapArray(JSONObject: data)
        }
    }
    
    
    struct GetUserDetail: Requestable {
        
        typealias Output = User?
        
        var httpMethod: HTTPMethod { return .get }
        
        var endpoint: String {
            return "/users/\(username)"
        }
        
        var username: String
        
        func decode(data: Any) -> Output {
            return Mapper<User>().map(JSONObject: data)
        }
        
    }
}
