//
//  LoadingTracker.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LoadingTracker: SharedSequenceConvertibleType {
    
    typealias SharingStrategy = DriverSharingStrategy
    
    private let subject = BehaviorRelay<Bool>(value: false)
    
    func trackingLoading<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: { _ in self.subject.accept(false)
        }, onCompleted: {
            self.subject.accept(false)
        }, onSubscribe: {
            self.subject.accept(true)
        })
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Bool> {
        return subject.asObservable().asDriverOnErrorJustComplete()
    }
    
    func asObservable() -> Observable<Bool> {
        return subject.asObservable()
    }
    
    func asBehaviorRelay() -> BehaviorRelay<Bool> {
        return subject
    }
}
extension ObservableConvertibleType {
    func trackLoading(_ loading: LoadingTracker) -> Observable<Element> {
        return loading.trackingLoading(from: self)
    }
}
