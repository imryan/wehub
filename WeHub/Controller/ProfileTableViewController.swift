//
//  ProfileTableViewController.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/6/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import UIKit
import SnapKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: Attributes
    
    private var profile: Profile? {
        didSet {
            self.reloadTable()
        }
    }
    
    private var repositories: [Repository]? {
        didSet {
            self.reloadTable()
        }
    }
    
    // MARK: UI
    
    fileprivate func setupUI() {
        self.title = "WeHub"
        setupTableView()
        
        if #available(iOS 11.0, *) {
            if let navigationController = self.navigationController {
                navigationController.navigationBar.prefersLargeTitles = true
            }
        }
    }
    
    fileprivate func setupTableView() {
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        self.tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderViewId")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Fetch profile
        GitHubHelper.shared.getUserProfile { (profile) in
            if let profile = profile {
                self.profile = profile
            }
        }
        
        // Fetch repositories
        GitHubHelper.shared.getUserRepositories { (repositories) in
            if let repositories = repositories {
                self.repositories = repositories
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UITableViewDelegate

extension ProfileTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repositories = repositories {
            let destination = RepositoryTableViewController()
            destination.repository = repositories[indexPath.row]
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 160 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let profile = profile, section == 0 else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderViewId") as! ProfileHeaderView
        header.setup(withProfile: profile)
        
        return header
    }
}

// MARK: - UITableViewDataSource

extension ProfileTableViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Repositories" : nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repositories = repositories {
            return repositories.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "RepoCellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? RepositoryTableViewCell
        
        if cell == nil {
            cell = RepositoryTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        if let repositories = repositories {
            let repository = repositories[indexPath.row]
            cell!.setup(withRepository: repository)
        }
        
        return cell!
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            self.tableView.endUpdates()
        }
    }
}
