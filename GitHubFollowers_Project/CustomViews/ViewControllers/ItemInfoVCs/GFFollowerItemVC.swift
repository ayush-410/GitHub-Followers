//
//  GFFollowerItemVC.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Singh on 10/01/24.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user?.followers ?? 0)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user?.following ?? 0)
        actionBtn.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
