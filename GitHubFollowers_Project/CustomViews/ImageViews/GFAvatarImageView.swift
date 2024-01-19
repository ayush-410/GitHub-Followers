//
//  GFAvatarImageView.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Kumar Singh on 02/12/23.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let placeholderImage = UIImage(named: "avatar-placeholder")
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadAvatarImage(from urlString: String) {
        NetworkManager.shared.downloadImage(urlString: urlString) { [weak self] image in
            guard let self, let image else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
