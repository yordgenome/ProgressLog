//
//  RegisterViewModel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/19.
//

import RxSwift
import RxCocoa

protocol RegisterViewModelInputs {
    var nameTextInput: AnyObserver<String> { get }
    var emailTextInput: AnyObserver<String> { get }
    var passwordTextInput: AnyObserver<String> { get }
}

protocol RegisterViewModelOutputs {
    var nameTextOutput: PublishSubject<String> { get }
    var emailTextOutput: PublishSubject<String> { get }
    var passwordTextOutput: PublishSubject<String> { get }
}

// RegisterViewControllerのvalidation
class RegisterViewModel: RegisterViewModelInputs, RegisterViewModelOutputs{
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Observable
    
    var nameTextOutput = PublishSubject<String>()
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
    
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Observer
    
    var nameTextInput: AnyObserver<String> {
        nameTextOutput.asObserver()
    }
    
    var emailTextInput: AnyObserver<String> {
        emailTextOutput.asObserver()
    }
    
    var passwordTextInput: AnyObserver<String> {
        passwordTextOutput.asObserver()
    }
    
    var validRegisterDriver: Driver<Bool> = Driver.never()
    
    init() {
        
        validRegisterDriver = validRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let nameValid = nameTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 2
            }

        let emailValid = emailTextOutput
            .asObservable()
            .map { text -> Bool in
                return self.validateEmail(candidate: text)
            }
        
        let passwordValid = passwordTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 6
            }
        
        Observable.combineLatest(nameValid, emailValid, passwordValid ) { $0 && $1 && $2 }
            .subscribe { validAll in
                self.validRegisterSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)
    }
    
    func validateEmail(candidate: String) -> Bool {
         let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        }
}
