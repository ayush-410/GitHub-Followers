//
//  FollowersListVC.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Kumar Singh on 21/11/23.
//

import UIKit

class FollowersListVC: GFDataLoadingVC {
    
    enum Section { case main }
    
    var username: String = ""
    var followers: [Follower] = []
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var filteredFollowers: [Follower] = []
    var isSearching: Bool = false
    var isLoadingMoreFollowers: Bool = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        navigationItem.rightBarButtonItem = addBtn
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Enter a username to search"
        navigationItem.searchController = searchController
    }
    
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😄."
                    DispatchQueue.main.async {
                        self.navigationItem.hidesSearchBarWhenScrolling = true
                        self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                
                DispatchQueue.main.async {
                    self.navigationItem.hidesSearchBarWhenScrolling = false
                }
                
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error Occured", message: error.rawValue, buttonTitle: "Ok")
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell else { return UICollectionViewCell() }
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    func updateData(on followers:[Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    @objc func addBtnTapped() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let follower):
                let follower = Follower(login: follower.login, avatarUrl: follower.avatarUrl)
                PersistenceManager.updateWith(favorite: follower, actionType: .add) { error in
                    guard let error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited the user 🎉", buttonTitle: "Hooray!")
                        return
                    }
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
    }
}

extension FollowersListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isActiveArray = isSearching ? filteredFollowers : followers
        let follower = isActiveArray[indexPath.item]
        let infoVC = InfoScreenVC()
        infoVC.username = follower.login
        infoVC.delegate = self
        let navVC = UINavigationController(rootViewController: infoVC)
        present(navVC, animated: true)
    }
}


extension FollowersListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            isSearching = false
            updateData(on: followers)
            return
        }
        isSearching = true
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased())})
        updateData(on: filteredFollowers)
    }
}

extension FollowersListVC: FollowerListVCDelegate {
    
    func getFollowersRequest(for userName: String) {
        self.username = userName
        page = 1
        title = userName
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: userName, page: page)
    }
    
    
}
