//
//  UserDetailsViewModel.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//
import RxSwift
import RxCocoa

class UserDetailsViewModel : BaseViewModel {
    private let getUserDetailUC = GetUserDetailUseCase()
    
    var user = BehaviorRelay<User?>(value: nil)
    
    func getDetails(_ username: String) {
        let params = GetUserDetailUseCase.Params(username: username)
        getUserDetailUC.execute(input: params)
            .trackError(errorTracker)
            .trackLoading(isLoadingTracker)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.user.accept(result)
            })
            .disposed(by: disposeBag)
    }
}
