//
//  GFDataLoadingVC.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Singh on 20/01/24.
//

import UIKit

class GFDataLoadingVC: UIViewController {

    var containerView: UIView!
    
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        
        let loaderView = UIActivityIndicatorView(style: .large)
        containerView.addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        loaderView.startAnimating()
    }
    
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
}
