//
//  ActivityIndicator.swift
//  MVVM+RxSwift
//
//  Created by Randy Efan Jayaputra on 22/09/22.
//

import Foundation
import RxSwift
import RxCocoa

final class ActivityIndicator: SharedSequenceConvertibleType {
    
    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _behavior = BehaviorRelay<Bool>(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        _loading = _behavior.asDriver().distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        _lock.lock()
        _behavior.accept(true)
        _lock.unlock()
    }
    
    private func sendStopLoading() {
        _lock.lock()
        _behavior.accept(false)
        _lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
    
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
