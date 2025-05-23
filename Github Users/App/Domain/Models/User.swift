//
//  User.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

/// A data model representing a GitHub user.
///
/// Contains basic profile information retrieved from the GitHub API.
///
/// - Parameters:
///   - id: Unique identifier of the user.
///   - name: Full name of the user.
///   - username: GitHub username (login).
///   - avatar: URL of the user's avatar image.
///   - profileUrl: Optional URL to the user's GitHub profile.
///   - location: Geographical location of the user.
///   - bio: Short biography or description provided by the user.
///   - blog: URL to the user's blog or website.
///   - followers: Number of followers the user has.
///   - following: Number of users the user is following.
struct User {
    var id: Int?
    var name: String?
    var username: String?
    var avatar: String?
    var profileUrl: String?
    var location: String?
    var bio: String?
    var blog: String?
    var followers: Int?
    var following: Int?
}
