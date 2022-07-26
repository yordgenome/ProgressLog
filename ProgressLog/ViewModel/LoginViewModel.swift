//
//  LoginViewModel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/20.
//

import RxSwift
import RxCocoa

protocol LoginViewModelInputs {
    var emailTextInput: AnyObserver<String> { get }
    var passwordTextInput: AnyObserver<String> { get }
}

protocol LoginViewModelOutputs {
    var emailTextOutput: PublishSubject<String> { get }
    var passwordTextOutput: PublishSubject<String> { get }
}

// LoginViewControllerのvalidation
class LoginViewModel: LoginViewModelInputs, LoginViewModelOutputs{
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Observable
    
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
    
    var validLoginSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Observer
    
    var emailTextInput: AnyObserver<String> {
        emailTextOutput.asObserver()
    }
    
    var passwordTextInput: AnyObserver<String> {
        passwordTextOutput.asObserver()
    }
    
    var validLoginDriver: Driver<Bool> = Driver.never()
    
    init() {
        
        validLoginDriver = validLoginSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
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
        
        Observable.combineLatest(emailValid, passwordValid ) { $0 && $1 }
            .subscribe { validAll in
                self.validLoginSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)
    }
    
    func validateEmail(candidate: String) -> Bool {
         let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        }
}
