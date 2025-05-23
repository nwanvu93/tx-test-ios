//
//  UserListViewModel.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import RxSwift
import RxCocoa

class UserListViewModel : BaseViewModel {
    private let getUserListUC = GetUserListUseCase()
    
    var users = BehaviorRelay<[User]>(value: [])
    
    private let START_PAGE = 0
    private var currentPage = 0
    
    func fetchUsers() {
        let nextSince = currentPage * Constants.API_PAGE_SIZE
        let params = GetUserListUseCase.Params(pageSize: Constants.API_PAGE_SIZE, since: nextSince)
        getUserListUC.execute(input: params)
            .trackError(errorTracker)
            .trackLoading(isLoadingTracker)
            .subscribe(onNext: { [weak self] users in
                guard let self = self else { return }
                self.users.accept(users)
            })
            .disposed(by: disposeBag)
    }
}
