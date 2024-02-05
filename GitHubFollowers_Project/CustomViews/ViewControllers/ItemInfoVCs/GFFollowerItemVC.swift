//
//  GFFollowerItemVC.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Singh on 10/01/24.
//

import UIKit

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User?)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GFFollowerItemVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user?.followers ?? 0)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user?.following ?? 0)
        actionBtn.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
    }
    
    
    override func actionBtnTapped() {
        super.actionBtnTapped()
        delegate?.didTapGetFollowers(for: user)
    }
}
