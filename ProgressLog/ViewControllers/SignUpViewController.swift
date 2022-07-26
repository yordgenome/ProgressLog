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
    
    private var workoutArray: [WorkoutModel] = []
    
    let disposeBag = DisposeBag()
    private let viewModel = RegisterViewModel()
    
    private let gradientView = GradientView()
    
    private let productLabel = SignUpLabel(text: "Progress Log", font: UIFont(name: "DevanagariSangamMN-Bold", size: 50)!)
    private let titleLabel = SignUpLabel(text: "アカウント登録", font: UIFont(name: "DevanagariSangamMN-Bold", size: 24)!)
    
    private let nameLabel = SignUpLabel(text: "名前")
    private let passwordLabel = SignUpLabel(text: "パスワード")
    private let emailLabel = SignUpLabel(text: "メールアドレス")
    
    private let nameTextField = SignUptTextField(placeholder: "名前", tag: 0, returnKeyType: .next)
    private let emailTextField = SignUptTextField(placeholder: "メールアドレス", tag: 1, returnKeyType: .next)
    private let passwordTextField = SignUptTextField(placeholder: "パスワード", tag: 2, returnKeyType: .done)
    
    private let registerButton = SignUpButton(text: "登録")
    
    private let moveToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("アカウントをお持ちの方はコチラ", for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupLayout()
        setupBindings()
    }
    
    func setupLayout() {
        addSubViews()
        passwordTextField.isSecureTextEntry = true
        if #available(iOS 12.0, *) { passwordTextField.textContentType = .oneTimeCode }
        
        gradientView.frame = view.bounds
        productLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 50, topPadding: 30)
        titleLabel.anchor(top: productLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 30)
        nameLabel.anchor(top: titleLabel.bottomAnchor, left: nameTextField.leftAnchor, width: 150, height: 20, topPadding: 30)
        nameTextField.anchor(top: nameLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        emailLabel.anchor(top: nameTextField.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        emailTextField.anchor(top: emailLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        passwordLabel.anchor(top: emailTextField.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        registerButton.anchor(top: passwordTextField.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 38)
        moveToLoginButton.anchor(top: registerButton.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 50)
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
        view.addSubview(registerButton)
        view.addSubview(moveToLoginButton)
    }
    
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
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.passwordTextInput.onNext(text ?? "")
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
    
    
    func moveToLogin() {
        let login = LoginViewController()
        present(login, animated: true)
    }
    
}

//MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            emailTextField.becomeFirstResponder()
        case 1:
            passwordTextField.becomeFirstResponder()
        case 2:
            passwordTextField.resignFirstResponder()
            
        default:
            break
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
}

