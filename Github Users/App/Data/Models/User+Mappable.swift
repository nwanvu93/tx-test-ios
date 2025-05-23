//
//  User.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import ObjectMapper

extension User : Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- (map["id"])
        name <- map["name"]
        username <- map["login"]
        avatar <- map["avatar_url"]
        profileUrl <- map["html_url"]
        location <- map["location"]
        bio <- map["bio"]
        blog <- map["blog"]
        followers <- map["followers"]
        following <- map["following"]
    }
}
