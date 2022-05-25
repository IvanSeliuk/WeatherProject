//
//  OpenNewsViewController.swift
//  WeatherProject
//
//  Created by Иван Селюк on 27.03.22.
//

import UIKit

class OpenNewsViewController: UIViewController {
    
    enum StateScrollPosition {
        case medium, small
        
        func getInsetsValues() -> UIEdgeInsets {
            switch self {
            case .medium: return UIEdgeInsets(top: UIScreen.main.bounds.height * 0.5, left: 0.0, bottom: 0.0, right: 0.0)
            case .small: return UIEdgeInsets(top: UIScreen.main.bounds.height * 0.71, left: 0.0, bottom: 0.0, right: 0.0)
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameJournalLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var screenImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    var selectedNews: Article?
    
    private let minScaleScreenImageView: CGFloat = 0.7
    private let maxScaleScreenImageView: CGFloat = 1.2
    
    var currentState: StateScrollPosition = .medium {
        didSet {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.scrollView.contentInset = self.currentState.getInsetsValues()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedNews = selectedNews else { return }
        setupInformations(with: selectedNews)
        setupScrollView()
    }
    
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
    
    private func setupScrollView() {
        scrollView.contentInset = currentState.getInsetsValues()
        scrollView.delegate = self
    }
}

extension OpenNewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scale = abs(scrollView.contentOffset.y) / (UIScreen.main.bounds.height * 0.5)
        if scale < minScaleScreenImageView { scale = minScaleScreenImageView }
        if scale > maxScaleScreenImageView { scale = maxScaleScreenImageView }
        screenImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        switch currentState {
        case .medium:
            if scrollView.contentOffset.y < -StateScrollPosition.medium.getInsetsValues().top {
                currentState = .small
            }
        case .small:
            if scrollView.contentOffset.y > -StateScrollPosition.small.getInsetsValues().top {
                currentState = .medium
            }
        }
    }
}
