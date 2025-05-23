//
//  UsersRepository.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import RxSwift

protocol UsersRepository {
    func fetchUsers(pageSize: Int, since: Int) -> Observable<[User]>
    func getUserDetail(username: String) -> Observable<User?>
}
