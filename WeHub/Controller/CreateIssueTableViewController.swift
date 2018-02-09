//
//  CreateIssueTableViewController.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/7/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import UIKit

class CreateIssueTableViewController: UITableViewController {
    
    // MARK: Attributes
    
    var repository: Repository?
    
    // MARK: Functions
    
    @objc fileprivate func createIssue() {
        self.view.endEditing(true)
        
        let title = textForCell(at: IndexPath(row: 0, section: 0))
        let body = textForCell(at: IndexPath(row: 1, section: 0))
        
        if let title = title, let body = body, let repository = repository {
            if title.isEmpty {
                self.showAlert(title: "Error", message: "Issue title must not be left blank.")
                return
            }
            
            let issue = Issue(number: nil, title: title, body: body, createdAt: Date(), state: Issue.State.Open)
            GitHubHelper.shared.createIssue(issue, inRepository: repository, block: { (success) in
                if success {
                    self.dismissView()
                } else {
                    self.showAlert(title: "Error", message: "Error creating issue.")
                }
            })
        }
    }
    
    fileprivate func textForCell(at indexPath: IndexPath) -> String? {
        if let cell = tableView.cellForRow(at: indexPath) as? IssueDetailTableViewCell {
            return cell.textView.text
        }
        
        return nil
    }
    
    fileprivate func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UI
    
    fileprivate func setupUI() {
        self.navigationItem.title = "Create Issue"
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        
        if #available(iOS 11.0, *) {
            if let navigationController = self.navigationController {
                navigationController.navigationBar.prefersLargeTitles = true
            }
        }
        
        setupBarButtonItems()
    }
    
    fileprivate func setupBarButtonItems() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createIssue))
        self.navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        self.navigationItem.leftBarButtonItem = cancelButton
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

extension CreateIssueTableViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CreateIssueTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? IssueDetailTableViewCell
        
        if cell == nil {
            cell = IssueDetailTableViewCell(style: .default, reuseIdentifier: cellId)
            cell?.textView.delegate = self
        }
        
        if indexPath.row == 0 {
            cell?.titleLabel.text = "Title"
            cell?.textView.becomeFirstResponder()
        } else {
            cell?.titleLabel.text = "Body"
        }
        
        return cell!
    }
}

// MARK: UITextViewDelegate

extension CreateIssueTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
