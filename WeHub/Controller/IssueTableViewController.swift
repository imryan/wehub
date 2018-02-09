//
//  IssueTableViewController.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/7/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import UIKit

class IssueTableViewController: UITableViewController {
    
    // MARK: Attributes
    
    var issue: Issue? {
        didSet {
            if let issue = issue {
                self.navigationItem.title = "Issue #\(issue.number!)"
                self.reloadTable()
            }
        }
    }
    
    // MARK: Functions
    
    fileprivate func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy h:mm a"
        return formatter
    }
    
    // MARK: UI
    
    fileprivate func setupUI() {
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        
        if #available(iOS 11.0, *) {
            if let navigationController = self.navigationController {
                navigationController.navigationBar.prefersLargeTitles = true
            }
        }
    }
    
    // MARK: Lifeycle
    
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

extension IssueTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - UITableViewDataSource

extension IssueTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? IssueDetailTableViewCell
        
        if cell == nil {
            cell = IssueDetailTableViewCell(style: .default, reuseIdentifier: cellId)
            cell?.textView.isUserInteractionEnabled = false
        }
        
        if let issue = issue {
            var title: String!
            var value: String!
            
            switch indexPath.row {
            case 0:
                title = "Title"
                value = issue.title!
                break
            case 1:
                title = "State"
                value = (issue.state == Issue.State.Open) ? "Open" : "Closed"
                break
            case 2:
                title = "Created"
                value = dateFormatter().string(from: issue.createdAt!)
                break
            case 3:
                title = "Body"
                value = issue.body!
                break
            default:
                break
            }
            
            cell?.titleLabel.text = title
            cell?.textView.text = value
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
