//
//  LogInViewController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
// MARK: - UIParts
    private let gradientView = CellBackgroundView()
    private let productLabel = SignUpLabel(text: "ログイン", font: UIFont(name: "DevanagariSangamMN-Bold", size: 36)!)
    private let passwordLabel = SignUpLabel(text: "パスワード")
    private let emailLabel = SignUpLabel(text: "メールアドレス")
    
    private let emailTextField = SignUptTextField(placeholder: "メールアドレス", tag: 0, returnKeyType: .next)
    private let passwordTextField = SignUptTextField(placeholder: "パスワード", tag: 1, returnKeyType: .done)

    private let loginButton = SignUpButton(text: "ログイン")
        private let passwordUpdateButton = SignUpButton()

    private let moveToSignUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(" アカウントをお持ちでない方はコチラ ", for: .normal)
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        addSubViews()
        passwordTextField.isSecureTextEntry = true
        if #available(iOS 12.0, *) { passwordTextField.textContentType = .oneTimeCode }

        gradientView.frame = view.bounds
        productLabel.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 50, topPadding: 50)
        emailLabel.anchor(top: productLabel.bottomAnchor, left: emailTextField.leftAnchor, width: 150, height: 20, topPadding: 16)
        emailTextField.anchor(top: emailLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        passwordLabel.anchor(top: emailTextField.bottomAnchor, left: emailLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        loginButton.anchor(top: passwordTextField.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 38)
        passwordUpdateButton.anchor(top: loginButton.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 38)
        moveToSignUpButton.anchor(top: passwordUpdateButton.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 30)
    }
    
    private func addSubViews(){
        view.addSubview(gradientView)
        view.addSubview(productLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(passwordUpdateButton)
        view.addSubview(moveToSignUpButton)
    }

// MARK: - Bindings
    private func setupBindings() {
        
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
        
        loginButton.rx.tap.asDriver().drive { [weak self] _ in
            Task{ await self?.loginWithFireAuth() }
        }
        .disposed(by: disposeBag)
        
        moveToSignUpButton.rx.tap.asDriver().drive { [ weak self ] _ in
            let signUp  = SignUpViewController()
            self?.navigationController?.pushViewController(signUp, animated: true)
        }
        .disposed(by: disposeBag)
        
        passwordUpdateButton.rx.tap.asDriver().drive { [ weak self ] _ in
            self?.showSendPasswordAlert()
        }
        .disposed(by: disposeBag)
        
        viewModel.validLoginDriver.drive { validAll in
            self.loginButton.isEnabled = validAll
            self.loginButton.backgroundColor = validAll ? .secondColor?.withAlphaComponent(0.9) : .init(white: 0.9, alpha: 0.9)
        }
        .disposed(by: disposeBag)
    }
    
    private func loginWithFireAuth() async {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let message = await UserModel.LoginAndGetError(email: email, password: password)
        if message == "ログインに成功しました" {
            dismiss(animated: true)
        } else {
            showAlert(title: "ログインに失敗しました", message: message)
        }
    }
    
    private func showAlert(title: String, message: String?) {
        print(#function)
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func showSendPasswordAlert() {
        print(#function)
        
        let remindPasswordAlert = UIAlertController(title: "パスワードをリセット", message: "メールアドレスを入力してください", preferredStyle: .alert)
               remindPasswordAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
               remindPasswordAlert.addAction(UIAlertAction(title: "リセット", style: .default, handler: { (action) in
                   let resetEmail = remindPasswordAlert.textFields?.first?.text
                   Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                       DispatchQueue.main.async {
                           if error != nil {
                               self.showAlert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。")
                           } else {
                               self.showAlert(title: "エラー", message: "このメールアドレスは登録されてません。")
                           }
                       }
                   })
               }))
               remindPasswordAlert.addTextField { (textField) in
                   textField.placeholder = "test@gmail.com"
               }
               self.present(remindPasswordAlert, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
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
