//
//  SettingsViewController.swift
//  ProgressLog
//
//  Created by 田原葉 on 2022/09/01.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth
import FirebaseFirestore


final class SettingsViewController: UIViewController, UITextFieldDelegate {
    
// MARK: - Properties
    private let disposeBag = DisposeBag()
    private var workoutData: [WorkoutModel] = []
    private var workoutMenuArray: [WorkoutMenu] = []
    
// MARK: - UIParts
    let headerView = SettingsHeaderView()
    let footerView = FooterView()
    private let nameLabel = SignUpLabel(text: "名前", fontColor: UIColor.outColor!)
    private let nameTextLabel: UILabel = SettingLabel()
    private let emailLabel = SignUpLabel(text: "メールアドレス", fontColor: UIColor.outColor!)
    private let emailTextLabel: UILabel = SettingLabel()
    
    private let baseDateLabel = SettingLabel(text: "基準となるトレーニング日")
    private let baseDateTextField: UITextField = SignUptTextField(placeholder: "", returnKeyType: .default)
    private let baseVolumeLabel = SettingLabel(text: "基準となるトレーニングボリューム")
    private let baseVolumeTextLabel: UILabel = SettingLabel()
    
    private let maxDateLabel = SettingLabel(text: "最大のトレーニング日")
    private let maxDateTextLabel: UILabel = SettingLabel()
    private let maxVolumeLabel = SettingLabel(text: "最大のトレーニングボリューム")
    private let maxVolumeTextLabel: UILabel = SettingLabel()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.locale = Locale.current
        dp.maximumDate = Date()
        dp.backgroundColor = UIColor.baseColor
        return dp
    }()
    
    private let logoutButton: UIButton = {
       let button = UIButton()
        button.setTitle("ログアウト", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = UIColor.baseColor!.cgColor
        
        return button
    }()
    
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .accentColor
        
        nameTextLabel.text = " " + UserData.name
        emailTextLabel.text  =  " " + UserData.email
        
        setupLayout()
        setupBinding()
        setupDatePicker()
    }
    
    private func setupLayout() {
        addsubViews()
        
        headerView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor, width: view.frame.width, bottomPadding: -36)
        footerView.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 80)
        
        nameLabel.anchor(top: headerView.bottomAnchor, left: nameTextLabel.leftAnchor, width: 150, height: 20, topPadding: 30)
        nameTextLabel.anchor(top: nameLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        emailLabel.anchor(top: nameTextLabel.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        emailTextLabel.anchor(top: emailLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        baseDateLabel.anchor(top: emailTextLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 20, topPadding: 16)
        baseDateTextField.anchor(top: baseDateLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        baseVolumeLabel.anchor(top: baseDateTextField.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 20, topPadding: 16)
        baseVolumeTextLabel.anchor(top: baseVolumeLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        maxDateLabel.anchor(top: baseVolumeTextLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 20, topPadding: 16)
        maxDateTextLabel.anchor(top: maxDateLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        maxVolumeLabel.anchor(top: maxDateTextLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 20, topPadding: 16)
        maxVolumeTextLabel.anchor(top: maxVolumeLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        logoutButton.anchor(top: maxVolumeTextLabel.bottomAnchor, centerX: view.centerXAnchor, width: 100, height: 30, topPadding: 38)

        
        if let data = UserDefaults.standard.getBaseVolume() {
            baseDateTextField.text = (data["dateString"]! as! String)
            baseVolumeTextLabel.text = " " + String(data["volume"]! as! Double) + "KG"
        } else {
            baseDateTextField.text = "トレーニング履歴がありません"
            baseVolumeTextLabel.text = " 0KG"
        }
        
        if let maxData = UserDefaults.standard.getMaxVolume() {
            maxDateTextLabel.text =  " " + (maxData["dateString"]! as! String)
            maxVolumeTextLabel.text = " " + String(maxData["volume"]! as! Double) + "KG"
        } else {
            maxDateTextLabel.text = "トレーニング履歴がありません"
            maxVolumeTextLabel.text = " 0KG"
        }
    }
    
    private func addsubViews() {
        view.addSubview(headerView)
        view.addSubview(footerView)
        view.addSubview(logoutButton)
        
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(nameTextLabel)
        view.addSubview(emailTextLabel)
        view.addSubview(baseDateLabel)
        view.addSubview(baseDateTextField)
        view.addSubview(baseVolumeLabel)
        view.addSubview(baseVolumeTextLabel)
        view.addSubview(maxDateLabel)
        view.addSubview(maxDateTextLabel)
        view.addSubview(maxVolumeLabel)
        view.addSubview(maxVolumeTextLabel)
    }
    
    private func setupDatePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        baseDateTextField.inputView = datePicker
        baseDateTextField.inputAccessoryView = toolbar
        baseDateTextField.delegate = self
    }
    
    @objc func done() {
        baseDateTextField.text = DateUtils.toStringFromDate(date: datePicker.date)
        getWorkoutData(dateString: DateUtils.toStringFromDate(date: datePicker.date))

        view.endEditing(true)
    }
    
    private func totalVolume() -> Double {
        let data = workoutData.map({ (workout) -> Double in
            return workout.volume
        })
        return data.reduce(0, +)
    }
    
    private func setupBinding() {
        
        headerView.editButton.rx.tap.asDriver().drive { [ weak self ] _ in
            guard let self = self else { return }
            let volume = Double(self.totalVolume())
            if volume != 0 {
                UserDefaults.standard.setBaseVolume(dateString: (self.baseDateTextField.text)!, volume: volume)
            } else {
                self.showAlert()
            }
        }
        .disposed(by: disposeBag)
        
        footerView.homeView.button?.rx.tap.asDriver().drive { [ weak self ] _ in
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            self?.present(homeVC, animated: true)
        }
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

        logoutButton.rx.tap.asDriver().drive { [ weak self ] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: "ログアウトしますか？", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
                   alert.addAction(UIAlertAction(title: "ログアウト", style: .default, handler: { (action) in
                       do {
                           try Auth.auth().signOut()
                           let signUpVC = SignUpViewController()
                           let nav = UINavigationController(rootViewController: signUpVC)
                           nav.modalPresentationStyle = .fullScreen
                           self.present(nav, animated: true)
                       } catch {
                           print("ログアウトに失敗", error)
                       }
                   }))
                   self.present(alert, animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alertVC = UIAlertController(title: nil, message: "トレーニング記録がありません", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func getWorkoutData(dateString: String) {
        workoutData.removeAll()
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection("workout").document(dateString).getDocument(source: .default) { snapshot, error in
            if let snapshot = snapshot {
                guard let mapData = snapshot.data() else {
                    print("データなし1")
                    self.baseVolumeTextLabel.text = " 0KG"
                    return }
                if mapData.count == 0 {
                    print("データなし2")
                    return
                } else {
                    for i in 0..<mapData.count {
                        if let valueData = mapData["\(i)"] as? [String: Any] {
                            let workoutName: String = valueData["workoutName"] as! String
                            let targetPart: String = valueData["targetPart"] as! String
                            let doneAt: Timestamp = valueData["doneAt"] as! Timestamp
                            let weight: Double = valueData["weight"] as! Double
                            let reps: Int = valueData["reps"] as! Int
                            let volume: Double = valueData["volume"] as! Double
                            
                            let data = WorkoutModel(doneAt: doneAt, targetPart: targetPart, workoutName: workoutName, weight: weight, reps: reps, volume: volume)
                            self.workoutData.append(data)
                        } else {
                            print("ワークアウトの取得に失敗1")
                            self.baseVolumeTextLabel.text = " 0KG"
                            return
                        }
                    }
                    self.baseVolumeTextLabel.text = " \(self.totalVolume())KG"
                    print("ワークアウトの取得に成功")
                }

            }
            
            if let error = error {
                self.baseVolumeTextLabel.text = " 0KG"
                print("ワークアウトの取得に失敗2:", error)
            }
        }
    }
}
