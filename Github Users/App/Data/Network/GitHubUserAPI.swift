//
//  GitHubUserAPI.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import Alamofire
import ObjectMapper

/// A namespace for GitHub user-related API requests.
enum GitHubUserAPI {
    
    /// A request to fetch the user list.
    struct FetchUsers: Requestable {
        
        /// The expected output type after decoding the API response.
        typealias Output = [User]?
        
        /// The HTTP method used for the request.
        var httpMethod: HTTPMethod { return .get }
        
        /// The endpoint path for fetching users.
        var endpoint: String { return "/users" }
        
        /// The number of users to fetch per page.
        var pageSize: Int
        
        /// The user index to start fetching from.
        var since: Int
        
        /// The query parameters to include in the API request.
        var params: Parameters {
            return [
                "per_page": pageSize,
                "since": since,
            ]
        }
        
        /// Decodes the API response data into an array of `User` objects.
        ///
        /// - Parameter data: The raw JSON response data.
        /// - Returns: An optional array of `User` instances.
        func decode(data: Any) -> Output {
            return Mapper<User>().mapArray(JSONObject: data)
        }
    }
    
    
    /// A request to fetch detailed information.
    struct GetUserDetail: Requestable {
        
        /// The expected output type after decoding the API response.
        typealias Output = User?
        
        /// The HTTP method used for the request.
        var httpMethod: HTTPMethod { return .get }
        
        /// The endpoint path for fetching the user details, using the specified `username`.
        var endpoint: String {
            return "/users/\(username)"
        }
        
        /// The GitHub username of the user to fetch.
        var username: String
        
        /// Decodes the API response data into a `User` object.
        ///
        /// - Parameter data: The raw JSON response data.
        /// - Returns: An optional `User` instance.
        func decode(data: Any) -> Output {
            return Mapper<User>().map(JSONObject: data)
        }
    }
}
