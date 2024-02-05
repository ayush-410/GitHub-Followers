//
//  GFRepoItemVC.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Singh on 10/01/24.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User?)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GFRepoItemVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user?.publicRepos ?? 0)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user?.publicGists ?? 0)
        actionBtn.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
    }
    
    
    override func actionBtnTapped() {
        super.actionBtnTapped()
        delegate?.didTapGitHubProfile(for: user)
    }
}

