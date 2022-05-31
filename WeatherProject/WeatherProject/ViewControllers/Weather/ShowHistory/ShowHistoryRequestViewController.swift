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
    var weatherDataSource = BehaviorSubject<[WeatherDate]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSegmentControl()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: true)
        MediaManager.shared.clearSoundPlayer()
    }
    
    private func setupUI() {
        setupTableView()
        setupButton()
        setupSegmentStyle()
    }
    
    private func setupTableView() {
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
      
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        tableView.register(UINib(nibName: "HistoryWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryWeatherTableViewCell")
        
        weatherDataSource
            .bind(to: tableView.rx.items) { (tableView, index, model) -> UITableViewCell in
                
                if self.segmentControl.selectedSegmentIndex == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryWeatherTableViewCell") as! HistoryWeatherTableViewCell
                    cell.setupParametresWithMap(with: model)
                    cell.userClickRemoveRowInMap = { [weak self] in
                        self?.setupSegmentControl() }
                    cell.selectionStyle = .none
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell") as! WeatherTableViewCell
                    cell.setupParametresWithCity(with: model)
                    cell.userClickRemoveRowInCity = { [weak self] in
                        self?.setupSegmentControl() }
                    cell.animationView.backgroundColor = UIColor(named: "ColorView")
                    cell.selectionStyle = .none
                    return cell
                }
            }.disposed(by: disposeBag)
    }
    
    private func setupSegmentStyle() {
        segmentControl.setTitle("tabBarItem.map".localized, forSegmentAt: 0)
        segmentControl.setTitle("City".localized, forSegmentAt: 1)
    }
    
    private func setupButton() {
        removeAllButton.layer.cornerRadius = 7
        removeAllButton.setTitle("Remove All".localized, for: .normal)

        removeAllButton
            .rx
            .tap
            .bind {
                MediaManager.shared.playSoundPlayer(with: SoundsChoice.delete.rawValue)
                CoreDataManager.shared.clearDataBase()
                self.weatherDataSource.onNext([])
                self.removeAllButton.isHidden = true
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    func setupSegmentControl() {
        if segmentControl.selectedSegmentIndex == 0 {
            let source = CoreDataManager.shared.getSourceFromDB(by: SourceValue.map.rawValue)
            weatherDataSource.onNext(source)
        } else {
            let city = CoreDataManager.shared.getSourceFromDB(by: SourceValue.city.rawValue)
            weatherDataSource.onNext(city)
        }
        removeAllButton.isHidden = try! weatherDataSource.value().count == 0
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        setupSegmentControl()
    }
}

extension ShowHistoryRequestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch segmentControl.selectedSegmentIndex {
        case 0: return 87.0
        case 1: return 218.0
        default: return 44.0
        }
    }
}
