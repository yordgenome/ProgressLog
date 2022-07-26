//
//  SetWorkoutViewModel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/25.
//

import RxSwift
import RxCocoa

protocol SetWorkoutViewModelInputs {
    var workoutNameTextInput: AnyObserver<String> { get }
    var targetPartTextInput: AnyObserver<String> { get }
    var weightTextInput: AnyObserver<String> { get }
    var repsTextInput: AnyObserver<String> { get }
}

protocol SetWorkoutViewModelOutputs {
    var workoutNameTextOutput: PublishSubject<String> { get }
    var targetPartTextOutput: PublishSubject<String> { get }
    var weightTextOutput: PublishSubject<String> { get }
    var repsTextOutput: PublishSubject<String> { get }
}

// WorkoutViewControllerのSetWorkoutViewのvalidation
class SetworkoutViewModel: SetWorkoutViewModelInputs, SetWorkoutViewModelOutputs{
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Observable
    
    var workoutNameTextOutput = PublishSubject<String>()
    var targetPartTextOutput = PublishSubject<String>()
    var weightTextOutput = PublishSubject<String>()
    var repsTextOutput = PublishSubject<String>()
    
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Observer
    
    var workoutNameTextInput: AnyObserver<String> {
        workoutNameTextOutput.asObserver()
    }
    
    var targetPartTextInput: AnyObserver<String> {
        targetPartTextOutput.asObserver()
    }
    
    var weightTextInput: AnyObserver<String> {
        weightTextOutput.asObserver()
    }
    
    var repsTextInput: AnyObserver<String> {
        repsTextOutput.asObserver()
    }
    
    var validRegisterDriver: Driver<Bool> = Driver.never()
    
    init() {
        
        validRegisterDriver = validRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let workoutNameValid = workoutNameTextOutput
            .asObservable()
            .map { text -> Bool in
                return !text.isEmpty
            }

        let targetPartValid = targetPartTextOutput
            .asObservable()
            .map { text -> Bool in
                return !text.isEmpty
            }
        
        let weightValid = weightTextOutput
            .asObservable()
            .map { text -> Bool in
                return !text.isEmpty && text != "0"
            }
        
        let repsValid = repsTextOutput
            .asObservable()
            .map { text -> Bool in
                return !text.isEmpty && text != "0"
            }
        
        Observable.combineLatest(workoutNameValid, targetPartValid, weightValid, repsValid) { $0 && $1 && $2 && $3}
            .subscribe { validAll in
                self.validRegisterSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)
    }
}
