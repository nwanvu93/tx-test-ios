//
//  UsersDataRepository.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import RxSwift

class UsersDataRepository: UsersRepository {
    
    func fetchUsers(pageSize: Int, since: Int) -> Observable<[User]> {
        return GitHubUserAPI.FetchUsers(pageSize: pageSize, since: since)
            .execute()
            .map({ response in
                return response ?? []
            })
    }
    
    func getUserDetail(username: String) -> Observable<User?> {
        return GitHubUserAPI.GetUserDetail(username: username)
            .execute()
            .map({ response -> User? in
                return response
            })
    }
}
