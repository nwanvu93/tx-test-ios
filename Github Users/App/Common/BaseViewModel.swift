//
//  BaseViewModel.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewModel {
    let disposeBag = DisposeBag()
    
    internal lazy var errorTracker = ErrorTracker()
    
    open var errorMessage: Observable<Error> {
        return errorTracker.asObservable()
    }
    let isLoading = BehaviorRelay<Bool>(value: false)
}
