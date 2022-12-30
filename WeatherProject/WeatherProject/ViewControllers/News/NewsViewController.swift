//
//  NewsViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 25.03.22.
//

import UIKit
import NVActivityIndicatorView

class NewsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex: Int?
    var news: News? {
        didSet {
            tableView.reloadData()
        }
    }
    //MARK: - Life cicle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.black
        setupTableView()
        getDataNews()
        activityIndicator.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MediaManager.shared.clearSoundPlayer()
    }
}

//MARK: - TableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else { return 0 }
        return news.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        if let item = news?.articles[indexPath.row] {
            cell.setupData(with: item)
        }
        return cell
    }
}

//MARK: - TableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 174.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = OpenNewsViewController.getInstanceController as? OpenNewsViewController else { return }
        vc.selectedNews = news?.articles[indexPath.row]
        MediaManager.shared.playSoundPlayer(with: SoundsChoice.list.rawValue)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
