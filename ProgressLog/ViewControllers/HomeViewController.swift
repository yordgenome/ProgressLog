//
//  ViewController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa
import Charts

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    let gradientView = GradientView()
    let footerView = FooterView()
    let headerView: UIView = HomeHeader()
    
    let textLabel: UILabel = {
        let label =  UILabel()
        label.text = "トレーニングボリューム成長率"
        label.textAlignment = .center
        label.textColor = UIColor.baseColor
        label.font = UIFont(name: "GeezaPro-Bold", size: 20)
        
        return label
    }()
    
    let resultView = ResultView()

    var user: User?
    let today = Date()

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .accentColor
        
        
        setupLayout()
        setupBinding()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil {
            let signUpVC = SignUpViewController()
            let nav = UINavigationController(rootViewController: signUpVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Task {
                user = try! await UserModel.getUserFromFirestore()
                UserData.name = user?.name ?? ""
                UserData.email = user?.email ?? ""
                UserData.createdAt = user?.createdAt ?? Timestamp()
            }
        }
        
        UserData.baseVolume = UserDefaults.standard.double(forKey: "baseVolume")
        
    }
    
    private func setupLayout() {
        view.addSubview(headerView)
        view.addSubview(footerView)
        view.addSubview(textLabel)
        view.addSubview(resultView)
        
        headerView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor, width: view.frame.width, bottomPadding: -36)
        textLabel.anchor(top: headerView.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width-60, height: 70, topPadding: 30)
        resultView.anchor(top: textLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 250, topPadding: 30)
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)
        
        resultView.resultLabel.text = resultText()

    }
    
    private func setupBinding() {

        footerView.menuView.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let regiWorkoutVC = RegisterMenuViewController()
            regiWorkoutVC.modalPresentationStyle = .fullScreen
            regiWorkoutVC.modalTransitionStyle  = .crossDissolve
            self?.present(regiWorkoutVC, animated: true)
        }).disposed(by: disposeBag)
        
        footerView.workoutView.button?.rx.tap.asDriver().drive { [ weak self ] _ in
            let workoutVC = WorkoutViewController()
            workoutVC.modalPresentationStyle = .fullScreen
            workoutVC.modalTransitionStyle  = .crossDissolve
            self?.present(workoutVC, animated: true)
        }
        .disposed(by: disposeBag)
        
        footerView.settingsView.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let settingsVC = SettingsViewController()
            settingsVC.modalPresentationStyle = .fullScreen
            settingsVC.modalTransitionStyle = .crossDissolve
            self?.present(settingsVC, animated: true)})
        .disposed(by: disposeBag)
        }
    
    func resultText() -> String {
        if let base = UserDefaults.standard.getBaseVolume(), let max = UserDefaults.standard.getMaxVolume() {
            let baseNum = base["volume"] as! Double
            let maxNum = max["volume"] as! Double
            if baseNum == 0 {
                return "0"
            } else {
                let result = Int(maxNum / baseNum * 100)
                return String(result)
            }
        }
        else {
            return "0"
        }
    }

}




//MARK: - UITableViewDataSource, UITableViewDelegate

