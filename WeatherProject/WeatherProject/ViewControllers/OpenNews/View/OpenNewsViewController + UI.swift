//
//  OpenNewsViewController + UI.swift
//  WeatherProject
//
//  Created by Иван Селюк on 4.06.22.
//

import UIKit

extension OpenNewsViewController {
    func dateFromApiString(_ evenDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_ENG")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let stringDate = dateFormatter.date(from: evenDate)
        dateFormatter.dateFormat = "d MMM yyyy, HH:mm"
        return dateFormatter.string(from: stringDate ?? Date())
    }
    
    func setupInformations(with selectedNews: Article) {
        nameJournalLabel.text = selectedNews.source.name.rawValue
        descriptionLabel.text = selectedNews.articleDescription
        dateLabel.text = dateFromApiString(selectedNews.publishedAt)
        authorLabel.text = "By \(selectedNews.author ?? "Anybody")"
        contentLabel.text = selectedNews.content
        FileServiceManager.shared.getImage(from: selectedNews.urlToImage) { [weak self] image in
            self?.screenImageView.image = image
            self?.backgroundView.image = image
        }
    }
    
    func setupScrollView() {
        scrollView.contentInset = currentState.getInsetsValues()
        scrollView.delegate = self
    }
}
