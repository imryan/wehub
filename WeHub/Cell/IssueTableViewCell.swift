//
//  IssueTableViewCell.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/6/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    
    // MARK: Setup
    
    func setup(withIssue issue: Issue) {
        DispatchQueue.main.async {
            self.accessoryType = .disclosureIndicator
            
            let imageName = (issue.state == Issue.State.Open) ? "issue-open" : "issue-closed"
            self.imageView?.image = UIImage(named: imageName)
            
            self.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            self.textLabel?.textColor = UIColor.black
            self.textLabel?.text = issue.title
            
            self.detailTextLabel?.textColor = UIColor.darkGray
            self.detailTextLabel?.text = issue.body
        }
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
