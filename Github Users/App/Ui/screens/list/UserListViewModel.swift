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
    
    /// Execute the request using `currentPage` and the `nextSince` value calculated from it.
    ///
    ///`nextSince` is calculated by multiplying `currentPage` with `Constants.API_PAGE_SIZE`.
    func fetchUsers() {
        let nextSince = currentPage * Constants.API_PAGE_SIZE
        let params = GetUserListUseCase.Params(pageSize: Constants.API_PAGE_SIZE, since: nextSince)
        getUserListUC.execute(input: params)
            .trackError(errorTracker)
            .trackLoading(isLoadingTracker)
            .subscribe(onNext: { [weak self] users in
                guard let self = self else { return }
                if self.currentPage == START_PAGE {
                    self.users.accept(users)
                } else {
                    self.users.accept(self.users.value + users)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Fetch the next page of data
    ///
    /// The page index will be increased automatically
    func loadMore() {
        // Skip loading more if it is currently loading
        if (isLoadingTracker.asBehaviorRelay().value) {
            return
        }
        
        // Increase the current page index
        currentPage += 1
        
        // Execute the request after changing the page index
        fetchUsers()
    }
    
    /// Reset data list to the first page by set the `START_PAGE` value to `currentPage`
    func refresh() {
        currentPage = START_PAGE
        fetchUsers()
    }
}
