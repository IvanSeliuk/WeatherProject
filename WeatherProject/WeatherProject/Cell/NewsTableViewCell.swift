//
//  NewsTableViewCell.swift
//  WeatherProject
//
//  Created by Иван Селюк on 26.03.22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nameJournalLabel: UILabel!
    @IBOutlet weak var screenImageView: UIImageView!
    
    func setupData(with news: Article) {
        authorLabel.text = "By \(news.author ?? "Anybody")"
        titleLabel.text = news.title
        nameJournalLabel.text = news.source.name.rawValue
        
        FileServiceManager.shared.getImage(from: news.urlToImage, completed: { [weak self] image in
            self?.screenImageView.image = image
        })
    }
}
