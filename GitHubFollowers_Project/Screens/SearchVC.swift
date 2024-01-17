//
//  SearchVC.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Kumar Singh on 11/11/23.
//

import UIKit

class SearchVC: UIViewController {

    let logoImageView = UIImageView()
    let userNameTextfield = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    var isUserNameEntered: Bool {
        return !userNameTextfield.text!.isEmpty
    }
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextfield()
        configureCallToActionButton()
        createDismissKeyboard()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        userNameTextfield.text = ""
    }
    
    
    private func createDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func pushFollowersListVC() {
        
        guard isUserNameEntered else {
            presentGFAlertOnMainThread(title: "No Username", message: "Please enter a username. We need to know who to look for 😄", buttonTitle: "Ok")
            return
        }
        
        userNameTextfield.resignFirstResponder()
        
        let followerListVC = FollowersListVC(username: userNameTextfield.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    

    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    private func configureTextfield() {
        view.addSubview(userNameTextfield)
        userNameTextfield.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTextfield.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextfield.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    private func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowersListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    

}


extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListVC()
        return true
    }
    
}
