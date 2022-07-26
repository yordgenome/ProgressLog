//
//  SetTargetViewModel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/10.
//

import RxSwift
import RxCocoa

// RegisterWorkoutControllerのSetTargetViewのvalidation
class SetTargetViewModel {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Observable
    
    var targetTextOutput = PublishSubject<String>()
    var validTextSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Observer
    
    var targetTextInput: AnyObserver<String> {
        targetTextOutput.asObserver()
    }
    
    var validTextDriver: Driver<Bool> = Driver.never()
    
    init() {
        
        validTextDriver = validTextSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let targetValid = targetTextOutput
            .asObservable()
            .map { text -> Bool in
                return !text.isEmpty
            }
        
        let repsValid = targetTextOutput
            .asObservable()
            .map { text -> Bool in
                return !text.isEmpty
            }

        Observable.combineLatest(targetValid, repsValid) { $0 && $1 }
            .subscribe { validAll in
                self.validTextSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)

    }
}

