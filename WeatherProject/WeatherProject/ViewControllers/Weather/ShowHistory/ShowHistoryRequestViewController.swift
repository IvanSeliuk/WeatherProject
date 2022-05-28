//
//  ShowHistoryRequestViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 17.04.22.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import CoreMedia

class ShowHistoryRequestViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var removeAllButton: UIButton!
    
    let disposeBag = DisposeBag()
    var arrayCityOffline = BehaviorSubject<[WeatherDate]>(value: [])
    var arrayMapOffline = BehaviorSubject<[WeatherDate]>(value: [])

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        arrayCityOffline
            .bind(to: tableView.rx.items(cellIdentifier:"WeatherTableViewCell" , cellType: WeatherTableViewCell.self)) { index, model, cell in
                cell.setupParametresWithCity(with: model)
                cell.userClickRemoveRowInCity = { [weak self] in
                    self?.segmentControlAction() }
                cell.animationView.backgroundColor = UIColor(named: "ColorView")
                cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        arrayMapOffline
            .bind(to: tableView.rx.items(cellIdentifier:"HistoryWeatherTableViewCell" , cellType: HistoryWeatherTableViewCell.self)) { index, model, cell in
                cell.setupParametresWithMap(with: model)
                cell.userClickRemoveRowInMap = { [weak self] in
                    self?.segmentControlAction() }
                cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        
//        Observable
//            .combineLatest(
//                arrayMapOffline,
//                arrayCityOffline
//            )
//            .map { (arrayCity, arrayMap) in
//                arrayCity.count > 0 && arrayMap > 0
//
//            }
        removeAllButton
            .rx
            .tap
            .bind { MediaManager.shared.playSoundPlayer(with: SoundsChoice.delete.rawValue)
                CoreDataManager.shared.clearDataBase()
                self.arrayCityOffline.do(onNext: { value in
                    print(value)
                })
                    self.arrayMapOffline.do(onNext: { value in
                    print(value.count)
                    })
                self.removeAllButton.isHidden = true
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        segmentControl
            .rx
            .selectedSegmentIndex
            .subscribe(onNext: { index in
                if index == 0 {
                    self.arrayMapOffline.do(onNext: { value in
                        print(value.count)
                    })
                    //    arrayMapOffline.value().removeAll()
                    
                    let source = CoreDataManager.shared.getSourceFromDB(by: SourceValue.map.rawValue)
                        self.arrayMapOffline.onNext(source)
                    
                } else {
                    
                    self.arrayCityOffline.do(onNext: { value in
                        print(value.count)
                    })
        //            arrayCityOffline
        //                .value()
        //                .removeAll()
                    
                    let city = CoreDataManager.shared.getSourceFromDB(by: SourceValue.city.rawValue)
                        self.arrayCityOffline.onNext(city)
                }
                self.buttonIsHidden()
            }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentControlAction()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
        MediaManager.shared.clearSoundPlayer()
    }
    
    private func setupUI() {
        setupButton()
        setupSegmentStyle()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        tableView.delegate = self
         
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        tableView.register(UINib(nibName: "HistoryWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryWeatherTableViewCell")
        
        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                print(indexPath)
            }).disposed(by: disposeBag)

    }
    
    private func setupSegmentStyle() {
        segmentControl.setTitle("tabBarItem.map".localized, forSegmentAt: 0)
        segmentControl.setTitle("City".localized, forSegmentAt: 1)
    }
    
    private func setupButton() {
        removeAllButton.layer.cornerRadius = 7
        removeAllButton.setTitle("Remove All".localized, for: .normal)
    }
    
    private func buttonIsHidden() {
        if try! arrayMapOffline.value().count == 0,
            try! arrayCityOffline.value().count == 0 {
            removeAllButton.isHidden = true
        } else {
            removeAllButton.isHidden = false
        }
    }
    
    func segmentControlAction() {
        if segmentControl.selectedSegmentIndex == 0 {
            arrayMapOffline.do(onNext: { value in
                print(value.count)
            })
            //                   afterNext: arrayMapOffline.value().removeAll()
            
            let source = CoreDataManager.shared.getSourceFromDB(by: SourceValue.map.rawValue)
            arrayMapOffline.onNext(source)
        } else {
            arrayCityOffline.do(onNext: { value in
                print(value.count)
            })
//            arrayCityOffline
//                .value()
//                .removeAll()
            //removeAll()
            let city = CoreDataManager.shared.getSourceFromDB(by: SourceValue.city.rawValue)
            arrayCityOffline.onNext(city)
        }
        buttonIsHidden()
    }
    
    
//    @IBAction func segmentControlAction(_ sender: Any) {
//        segmentControlAction()
//    }
    
//    @IBAction func removeAllDataBaseAction(_ sender: Any) {
//        MediaManager.shared.playSoundPlayer(with: SoundsChoice.delete.rawValue)
//        CoreDataManager.shared.clearDataBase()
//        arrayMapOffline.removeAll()
//        arrayCityOffline.removeAll()
//        removeAllButton.isHidden = true
//        tableView.reloadData()
//    }
}

//extension ShowHistoryRequestViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        switch segmentControl.selectedSegmentIndex {
//        case 0: return arrayMapOffline.count
//        case 1: return arrayCityOffline.count
//        default: return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch segmentControl.selectedSegmentIndex {
//        case 0:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryWeatherTableViewCell", for: indexPath) as? HistoryWeatherTableViewCell else { return UITableViewCell() }
//            cell.setupParametresWithMap(with: arrayMapOffline[indexPath.section])
//            cell.userClickRemoveRowInMap = { [weak self] in
//                self?.segmentControlAction() }
//            cell.selectionStyle = .none
//            return cell
//
//        case 1:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
//            cell.setupParametresWithCity(with: arrayCityOffline[indexPath.section])
//            cell.userClickRemoveRowInCity = { [weak self] in
//                self?.segmentControlAction() }
//            cell.animationView.backgroundColor = UIColor(named: "ColorView")
//            cell.selectionStyle = .none
//            return cell
//
//        default: return UITableViewCell()
//        }
//    }
//}

extension ShowHistoryRequestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch segmentControl.selectedSegmentIndex {
        case 0: return 87.0
        case 1: return 218.0
        default: return 44.0
        }
    }
    
    // MARK: отступы между TableViewCell (grouped, height header = 3, cell - через section, а не Row)
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
}
