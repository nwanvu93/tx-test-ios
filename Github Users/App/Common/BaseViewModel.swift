//
//  BaseViewModel.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import RxSwift
import RxCocoa

/// A base view model providing common reactive properties for tracking loading state and errors.
/// 
/// This class uses RxSwift to expose:
/// - `errorMessage`: an observable stream of errors, tracked via `ErrorTracker`.
/// - `isLoading`: an observable boolean indicating whether a loading operation is in progress, tracked via `LoadingTracker`.
/// 
/// Subclasses can inherit this functionality to manage loading and error states in a reactive and consistent manner.
class BaseViewModel {
    let disposeBag = DisposeBag()
    
    internal lazy var errorTracker = ErrorTracker()
    internal lazy var isLoadingTracker = LoadingTracker()
    
    open var errorMessage: Observable<Error> {
        return errorTracker.asObservable()
    }
    var isLoading: Observable<Bool> {
        return isLoadingTracker.asObservable()
    }
}
