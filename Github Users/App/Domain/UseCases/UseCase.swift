//
//  UseCase.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//
import RxSwift

protocol UseCase {
    associatedtype Output
    associatedtype Input
    func run(input: Input) -> Observable<Output>
}

extension UseCase {
    func execute(input: Input) -> Observable<Output> {
        return self.run(input: input)
            .observe(on: MainScheduler.instance)
    }
}

struct ParamNone {
    
}

extension UseCase where Input == ParamNone {
    func execute() -> Observable<Output> {
        return execute(input: ParamNone())
    }
}
