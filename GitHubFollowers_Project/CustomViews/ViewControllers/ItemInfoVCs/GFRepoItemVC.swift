//
//  GFRepoItemVC.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Singh on 10/01/24.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user?.publicRepos ?? 0)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user?.publicGists ?? 0)
        actionBtn.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}

