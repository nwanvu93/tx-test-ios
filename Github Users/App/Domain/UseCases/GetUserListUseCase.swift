//
//  GetUserListUseCase.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//
import RxSwift

class GetUserListUseCase : UseCase {
    typealias Output = [User]
    
    typealias Input = Params
    
    struct Params {
        var pageSize: Int
        var since: Int
    }
    
    let repository: UsersRepository
    
    init(repository: UsersRepository = UsersDataRepository()) {
        self.repository = repository
    }
    
    func run(input: Params) -> Observable<Output> {
        repository.fetchUsers(pageSize: input.pageSize, since: input.since)
    }
}
