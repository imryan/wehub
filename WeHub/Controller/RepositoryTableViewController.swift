//
//  RepositoryTableViewController.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/7/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import UIKit

class RepositoryTableViewController: UITableViewController {
    
    // MARK: Attributes
    
    var repository: Repository? {
        didSet {
            refreshIssues()
        }
    }
    
    var issues: [Issue]? {
        didSet {
            self.reloadTable()
        }
    }
    
    // MARK: Functions
    
    @objc fileprivate func createIssue() {
        if let repository = repository {
            let createIssueController = CreateIssueTableViewController()
            createIssueController.repository = repository
            
            let navigationController = UINavigationController(rootViewController: createIssueController)
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        }
    }
    
    fileprivate func refreshIssues() {
        if let repository = repository {
            GitHubHelper.shared.getIssuesForRepository(repository) { (issues) in
                if let issues = issues {
                    self.issues = issues
                }
            }
        }
    }
    
    // MARK: UI
    
    fileprivate func setupUI() {
        self.navigationItem.title = repository?.name ?? "Repository"
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        
        if #available(iOS 11.0, *) {
            if let navigationController = self.navigationController {
                navigationController.navigationBar.prefersLargeTitles = true
            }
        }
        
        let addIssueButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createIssue))
        self.navigationItem.rightBarButtonItem = addIssueButton
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDelegate

extension RepositoryTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let issues = issues {
            let destination = IssueTableViewController()
            destination.issue = issues[indexPath.row]
            
            self.navigationController?.pushViewController(destination, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension RepositoryTableViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if repository != nil {
            return "Issues"
        }
        
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let issues = issues {
            return (issues.count > 0) ? issues.count : 1
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "IssueCellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? IssueTableViewCell
        
        if cell == nil {
            cell = IssueTableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        if let issues = issues {
            if issues.count == 0 {
                cell?.textLabel?.text = "No issues"
                cell?.textLabel?.textColor = UIColor.darkGray
                cell?.accessoryType = .none
                cell?.isUserInteractionEnabled = false
            } else {
                let issue = issues[indexPath.row]
                cell!.setup(withIssue: issue)
            }
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
