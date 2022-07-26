//
//  TrainingLogController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/01.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa


final class WorkoutViewController: UIViewController {
    
//MARK: - Properties
    private let viewModel = SetworkoutViewModel()
    private let gradientView = GradientView()
    private let footerView = MuscleFooterView()
    private let headerView = DatePickView()
    private let setWorkoutView = SetWorkoutView()
    private let disposeBag = DisposeBag()
    
    private var workoutData: [WorkoutModel] = []
    private var workoutMenuArray: [WorkoutMenu] = []
    
    var selectedTarget = 0
    
    var currentDate: Date?
      
    private let todaysVolumeLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .endColor
        label.font = UIFont(name: "GeezaPro-Bold", size: 16)
        return label
    }()
    
    private let workoutTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: WorkoutCell.identifier)
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
//MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        workoutMenuArray = UserDefaults.standard.getWorkoutMenu("WorkoutMenu") ?? []
        if workoutMenuArray.isEmpty {
            setupWorkoutMenu()
        }
  
        currentDate = DateUtils.toDateFromString(string: headerView.dateTextField.text!)
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        todaysVolumeLabel.text = "トレーニングボリューム：\(self.totalVolume())KG"

        setupLayout()
        setupBindings()
    }
    
    private func getWorkoutData(dateString: String) {
        workoutData.removeAll()
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection("workout").document(dateString).getDocument(source: .default) { snapshot, error in
            print(#function)
            if let snapshot = snapshot {
                guard let mapData = snapshot.data() else {
                    self.workoutTableView.reloadData()
                    self.todaysVolumeLabel.text = "トレーニングボリューム：\(self.totalVolume())KG"
                    return }
                if mapData.count == 0 {
                    return
                } else {
                    print("mapData:", mapData)
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
                            print("ワークアウトの取得に失敗")
                            return
                        }
                    }
                    self.todaysVolumeLabel.text = "トレーニングボリューム：\(self.totalVolume())KG"
                    print("ワークアウトの取得に成功")
                }
                self.workoutTableView.reloadData()
                self.todaysVolumeLabel.text = "トレーニングボリューム：\(self.totalVolume())KG"
            }
            
            if let error = error {
                self.workoutTableView.reloadData()
                self.todaysVolumeLabel.text = "トレーニングボリューム：\(self.totalVolume())KG"
                print("ワークアウトの取得に失敗:", error)
            }
        }
    }
    
    private func setupWorkoutMenu() {
        workoutMenuArray.append(WorkoutMenu(target: "胸", menu: ["ベンチプレス", "ダンベルフライ", "ディップス"]))
        workoutMenuArray.append(WorkoutMenu(target: "肩", menu: ["ショルダープレス", "サイドレイズ", "リアレイズ"]))
        workoutMenuArray.append(WorkoutMenu(target: "腕", menu: ["アームカール", "ハンマーカール", "スカルクラッシャー"]))
        workoutMenuArray.append(WorkoutMenu(target: "背", menu: ["ラットプルダウン", "ベントオーバーロウ", "バックエクステンション"]))
        workoutMenuArray.append(WorkoutMenu(target: "脚", menu: ["スクワット", "レッグエクステンション", "レッグカール"]))
        workoutMenuArray.append(WorkoutMenu(target: "腹", menu: ["シットアップ", "ツイストシットアップ", "レッグレイズ"]))
        workoutMenuArray.append(WorkoutMenu(target: "他", menu: []))
    }
    
    private func setupLayout() {
        view.addSubview(gradientView)
        view.addSubview(headerView)
        view.addSubview(todaysVolumeLabel)
        view.addSubview(setWorkoutView)
        view.addSubview(workoutTableView)
        view.addSubview(footerView)
        
        gradientView.frame = view.bounds
        headerView.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.width, height: 80)
        todaysVolumeLabel.anchor(top: headerView.bottomAnchor, centerX: view.centerXAnchor, width: view.frame.width, height: 18)
        setWorkoutView.anchor(top: todaysVolumeLabel.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 100)
        workoutTableView.anchor(top: setWorkoutView.bottomAnchor, bottom: footerView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.bounds.width, topPadding: 5, bottomPadding: 5)
        footerView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 120)
    }

    private func totalVolume() -> Double {
        let data = workoutData.map({ (workout) -> Double in
            return workout.volume
        })
        print("workoutData:", workoutData)
        print("data:", data)
        print("data.reduce(0, +):", data.reduce(0, +))
        return data.reduce(0, +)
    }
    
//MARK: - Bindings
    private func setupBindings() {
        
        
        SetupTextFields()
        // 日付処理
        headerView.dateTextField.rx.text.asDriver().drive { [weak self] text in
            guard let self = self else { return }
            self.currentDate = DateUtils.toDateFromString(string: text!)
            self.getWorkoutData(dateString: text!)
        }
        .disposed(by: disposeBag)
        
        headerView.previousDayButton.rx.tap.asDriver().drive { [weak self] _ in
            guard let self = self else { return }
            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate!)!
            self.headerView.dateTextField.text = DateUtils.toStringFromDate(date: self.currentDate!)
            self.getWorkoutData(dateString: self.headerView.dateTextField.text!)

        }.disposed(by: disposeBag)

        headerView.nextDayButton.rx.tap.asDriver().drive { [weak self] _ in
            guard let self = self else { return }
            if self.currentDate == DateUtils.toDateFromString(string: DateUtils.toStringFromDate(date: Date())) {
                return
            } else {
                self.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate!)!
                self.headerView.dateTextField.text = DateUtils.toStringFromDate(date: self.currentDate!)
            }
            self.getWorkoutData(dateString: self.headerView.dateTextField.text!)
        }.disposed(by: disposeBag)
        
        // ワークアウト登録
        setWorkoutView.setButton.rx.tap.asDriver().drive {[ weak self ] _ in
            guard let self = self else { return }
            let targetPart = self.setWorkoutView.targetPartTextField.text!
            let workoutName = self.setWorkoutView.workoutNameTextField.text!
            let weight = Double(self.setWorkoutView.weightTextField.text!)!
            let reps = Int(self.setWorkoutView.repsTextField.text!)!
            let workout = WorkoutModel(doneAt: Timestamp(date: self.currentDate!), targetPart: targetPart, workoutName: workoutName, weight: weight, reps: reps, volume: weight*Double(reps))
            self.workoutData.append(workout)
            self.workoutTableView.reloadData()
            self.todaysVolumeLabel.text = "トレーニングボリューム：\(self.totalVolume())KG"
            print(self.workoutData)
            Task { do { try await UserModel.setWorkoutToFirestore(workout: self.workoutData, dateString: DateUtils.toStringFromDate(date: self.currentDate!))
            } catch { print("ワークアウトの登録に失敗") }
            }
        }.disposed(by: disposeBag)

        setWorkoutView.clearButton.rx.tap.asDriver().drive {[ weak self ] _ in
            guard let self = self else { return }
            self.setWorkoutView.targetPartTextField.text = ""
            self.setWorkoutView.workoutNameTextField.text = ""
            self.setWorkoutView.repsTextField.text = ""
            self.setWorkoutView.weightTextField.text = ""
        }.disposed(by: disposeBag)
        
        setWorkoutView.workoutNameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.workoutNameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        setWorkoutView.targetPartTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.setWorkoutView.workoutNameTextField.text = ""
                self?.viewModel.targetPartTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        setWorkoutView.weightTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.weightTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        setWorkoutView.repsTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.repsTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        viewModel.validRegisterDriver.drive { validAll in
            print("validAll:", validAll)
            self.setWorkoutView.setButton.isEnabled = validAll
            self.setWorkoutView.setButton.backgroundColor = validAll ? .outColor : .init(white: 0.9, alpha: 0.9)
        }
        .disposed(by: disposeBag)
        
        // footerViewの各ボタンの遷移処理
        
        footerView.homeView.button?.rx.tap.asDriver().drive { [ weak self ] _ in
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self?.present(homeVC, animated: true)
        }
        .disposed(by: disposeBag)
        
        footerView.menuView.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let regiWorkoutVC = RegisterMenuViewController()
            regiWorkoutVC.modalPresentationStyle = .fullScreen
            self?.present(regiWorkoutVC, animated: true)
        }).disposed(by: disposeBag)
                                                 
    }
    
    private func SetupTextFields() {
        
        // targetPartTextField
        let targetPartPicker = UIPickerView()
        targetPartPicker.tag = 1
        targetPartPicker.delegate = self
        targetPartPicker.dataSource = self
        setWorkoutView.targetPartTextField.inputView = targetPartPicker
        let targetPartToolbar = UIToolbar()
        targetPartToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem1 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker1))
        targetPartToolbar.setItems([space1, doneButtonItem1], animated: true)
        setWorkoutView.targetPartTextField.inputAccessoryView = targetPartToolbar
        
        // workoutNameTextField
        let workoutNamePicker = UIPickerView()
        workoutNamePicker.tag = 2
        workoutNamePicker.delegate = self
        workoutNamePicker.dataSource = self
        setWorkoutView.workoutNameTextField.inputView = workoutNamePicker
        let workoutNameToolbar = UIToolbar()
        workoutNameToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem2 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker2))
        workoutNameToolbar.setItems([space2, doneButtonItem2], animated: true)
        setWorkoutView.workoutNameTextField.inputAccessoryView = workoutNameToolbar

        // weightTextField
        let weightToolbar = UIToolbar()
        weightToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem3 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker3))
        weightToolbar.setItems([space3, doneButtonItem3], animated: true)
        setWorkoutView.weightTextField.inputAccessoryView = weightToolbar
        
        // repsTextField
        let repsToolbar = UIToolbar()
        repsToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem4 = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(donePicker4))
        repsToolbar.setItems([space4, doneButtonItem4], animated: true)
        setWorkoutView.repsTextField.inputAccessoryView = repsToolbar
    }
    
    @objc func donePicker1() {
        setWorkoutView.workoutNameTextField.becomeFirstResponder()
    }
    @objc func donePicker2() {
        setWorkoutView.weightTextField.becomeFirstResponder()
    }
    @objc func donePicker3() {
        setWorkoutView.repsTextField.becomeFirstResponder()
    }
    @objc func donePicker4() {
        setWorkoutView.repsTextField.resignFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            setWorkoutView.workoutNameTextField.becomeFirstResponder()
        case 1:
            setWorkoutView.weightTextField.becomeFirstResponder()
        case 2:
            setWorkoutView.repsTextField.becomeFirstResponder()
        case 3:
            setWorkoutView.repsTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workoutData.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutCell.identifier, for: indexPath) as! WorkoutCell
        cell.menuLabel.text = workoutData[indexPath.section].workoutName
        cell.targetPartLabel.text = workoutData[indexPath.section].targetPart
        cell.weightLabel.text = workoutData[indexPath.section].weight.description + "KG"
        cell.repsLabel.text = workoutData[indexPath.section].reps.description + "回"
        cell.TotalVolumeLabel.text = workoutData[indexPath.section].volume.description + "KG"
        cell.selectionStyle = .none
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }


    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") {action, view, completionHandler in
            
            let alert = UIAlertController(title: "確認", message: "選択中のデータを削除しますか?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                self.workoutData.remove(at: indexPath.section)
                let indexSet = NSMutableIndexSet()
                indexSet.add(indexPath.section)
                tableView.deleteSections(indexSet as IndexSet, with: .fade)
                
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}


//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension WorkoutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return workoutMenuArray.count
        } else {
            return workoutMenuArray[selectedTarget].menu.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            selectedTarget = row
            return workoutMenuArray[row].target
        } else {
            return workoutMenuArray[selectedTarget].menu[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            setWorkoutView.targetPartTextField.text = workoutMenuArray[row].target
        } else {
            setWorkoutView.workoutNameTextField.text = workoutMenuArray[selectedTarget].menu[row]
        }
    }
}
