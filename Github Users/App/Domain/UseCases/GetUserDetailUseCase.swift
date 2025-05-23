//
//  GetUserDetailUseCase.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import RxSwift

class GetUserDetailUseCase : UseCase {
    typealias Output = User?
    
    typealias Input = Params
    
    struct Params {
        var username: String
    }
    
    let repository: UsersRepository
    
    init(repository: UsersRepository = UsersDataRepository()) {
        self.repository = repository
    }
    
    func run(input: Params) -> Observable<Output> {
        repository.getUserDetail(username: input.username)
    }
}
