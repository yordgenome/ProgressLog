//
//  SignUpViewController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {

// MARK: - Properties
    private var workoutArray: [WorkoutModel] = []
    private let disposeBag = DisposeBag()
    private let viewModel = SignUpViewModel()
    
    
// MARK: - UIParts
    private let gradientView = CellBackgroundView()
    
    private let productLabel = SignUpLabel(text: "Progress Log", font: UIFont(name: "DevanagariSangamMN-Bold", size: 50)!)
    private let titleLabel = SignUpLabel(text: "アカウント登録", font: UIFont(name: "DevanagariSangamMN-Bold", size: 24)!)
    
    private let nameLabel = SignUpLabel(text: "名前")
    private let passwordLabel = SignUpLabel(text: "パスワード")
    private let emailLabel = SignUpLabel(text: "メールアドレス")
    private let password2Label = SignUpLabel(text: "確認用パスワード")
    private let email2Label = SignUpLabel(text: "確認用メールアドレス")
    
    private let nameTextField = SignUptTextField(placeholder: "名前", tag: 0, returnKeyType: .next)
    private let emailTextField = SignUptTextField(placeholder: "メールアドレス", tag: 1, returnKeyType: .next)
    private let email2TextField = SignUptTextField(placeholder: "確認用メールアドレス", tag: 2, returnKeyType: .next)
    private let passwordTextField = SignUptTextField(placeholder: "パスワード", tag: 3, returnKeyType: .next)
    private let password2TextField = SignUptTextField(placeholder: "確認用パスワード", tag: 4, returnKeyType: .done)
    
    private let registerButton = SignUpButton(text: "登録")
    
    private let moveToLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(" アカウントをお持ちの方はコチラ ", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = UIColor.secondColor?.withAlphaComponent(0.9).cgColor
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = .init(width: 1.5, height: 2)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 6
        return button
    }()
    
// MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        addSubViews()
        passwordTextField.isSecureTextEntry = true
        if #available(iOS 12.0, *) { passwordTextField.textContentType = .oneTimeCode }
        password2TextField.isSecureTextEntry = true
        if #available(iOS 12.0, *) { passwordTextField.textContentType = .oneTimeCode }
        
        gradientView.frame = view.bounds
        productLabel.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 50, topPadding: 50)
        titleLabel.anchor(top: productLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 20)
        nameLabel.anchor(top: titleLabel.bottomAnchor, left: nameTextField.leftAnchor, width: 150, height: 20, topPadding: 16)
        nameTextField.anchor(top: nameLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        emailLabel.anchor(top: nameTextField.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        emailTextField.anchor(top: emailLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        email2Label.anchor(top: emailTextField.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        email2TextField.anchor(top: email2Label.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        passwordLabel.anchor(top: email2TextField.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        password2Label.anchor(top: passwordTextField.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        password2TextField.anchor(top: password2Label.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        registerButton.anchor(top: password2TextField.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 38)
        moveToLoginButton.anchor(top: registerButton.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 38)
    }
    
    private func addSubViews(){
        view.addSubview(gradientView)
        view.addSubview(productLabel)
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(email2Label)
        view.addSubview(email2TextField)
        view.addSubview(password2Label)
        view.addSubview(password2TextField)
        view.addSubview(registerButton)
        view.addSubview(moveToLoginButton)
    }

// MARK: - Bindings
    private func setupBindings() {
        
        nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.nameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        email2TextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                
                self?.viewModel.email2TextInput.onNext(text == self!.emailTextField.text)
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        password2TextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                
                self?.viewModel.password2TextInput.onNext(text == self!.passwordTextField.text)
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.tap.asDriver().drive { [weak self] _ in
            //登録時の処理
            Task {await self?.createUser()}
        }
        .disposed(by: disposeBag)
        
        moveToLoginButton.rx.tap.asDriver().drive { [ weak self ] _ in
            let loginVC = LoginViewController()
            self?.navigationController?.pushViewController(loginVC, animated: true)
        }
        .disposed(by: disposeBag)
        
        viewModel.validRegisterDriver.drive { validAll in
            self.registerButton.isEnabled = validAll
            self.registerButton.backgroundColor = validAll ? .secondColor?.withAlphaComponent(0.9) : .init(white: 0.9, alpha: 0.9)
        }
        .disposed(by: disposeBag)
    }
    
    private func createUser() async {
        guard let email = emailTextField.text,
              let name = nameTextField.text,
              let password = passwordTextField.text else { return }
        let message = await UserModel.signUpAndGetError(name: name, email: email, password: password)
        if message == "アカウント登録が完了しました" {
            dismiss(animated: true)
        } else {
            showAlert(title: "アカウント登録に失敗しました", message: message)
        }
    }
    
    private func showAlert(title: String, message: String?) {
        print(#function)
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            emailTextField.becomeFirstResponder()
        case 1:
            email2TextField.becomeFirstResponder()
        case 2:
            passwordTextField.becomeFirstResponder()
        case 3:
            password2TextField.becomeFirstResponder()
        case 4:
            password2TextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

