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


class HomeViewController: UIViewController {

//    var barChartView = HorizontalBarChartView()
    
    
    //MARK: - Properties
    let gradientView = GradientView()
    let footerView = FooterView()
    
    
    var user: User?
    let today = Date()

    let disposeBag = DisposeBag()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("logout", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

//        barChartView.delegate = self
        
        setupLayout()
        setupBinding()
//        setbarChart()
    }
    
//    private func setbarChart() {
//        var entries = [BarChartDataEntry]()
//        for x in 0..<10 {
//            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
//        }
//
//        let set = BarChartDataSet(entries: entries)
//        set.colors = ChartColorTemplates.vordiplom()
//        let data = BarChartData(dataSet: set)
//        barChartView.data = data
//
//    }


    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil {
            let signUpVC = SignUpViewController()
            let nav = UINavigationController(rootViewController: signUpVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else { return }
//            Task {
//                user = try! await UserModel.getUserFromFirestore()
//            }
            Firestore.firestore().collection("users").document(uid).getDocument(completion: { document, error in
                if let document = document {
                    let name = document.data()!["name"] as! String
                    let email = document.data()!["email"] as! String
                    let createdAt = document.data()!["createdAt"] as! Timestamp

                    self.user = User(id: uid, name: name, email: email, createdAt: createdAt)
                    print("ユーザー情報の取得に成功", self.user as Any)
                }
                if error != nil {
                    print("ユーザー情報の取得に失敗", error as Any)
                }
            })
        }
    }
    
    private func setupLayout() {
//        view.addSubview(gradientView)
//        view.addSubview(barChartView)
        view.addSubview(footerView)
        view.addSubview(logoutButton)
//        gradientView.frame = view.bounds
//        barChartView.anchor(top: view.topAnchor, left: view.leftAnchor, width: view.bounds.width, height: view.bounds.width, topPadding: 80)
//        footerView.anchor(top: view.safeAreaLayoutGuide.bottomAnchor, bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, topPadding: -60)
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)

        logoutButton.anchor(bottom: footerView.topAnchor, right: view.rightAnchor, width: 100, height: 50)
    }
    
    private func setupBinding() {
        
        footerView.chartView.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let regiWorkoutVC = RegisterMenuViewController()
            regiWorkoutVC.modalPresentationStyle = .fullScreen
            regiWorkoutVC.modalTransitionStyle  = .crossDissolve

            self?.present(regiWorkoutVC, animated: true)})
            .disposed(by: disposeBag)
        
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

        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc private func logout() {
        do {
            try Auth.auth().signOut()
            let signUpVC = SignUpViewController()
            let nav = UINavigationController(rootViewController: signUpVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch {
            print("ログアウトに失敗", error)
        }
    }
}





//MARK: - UITableViewDataSource, UITableViewDelegate


