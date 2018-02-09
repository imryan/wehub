//
//  RepositoryTableViewCell.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/6/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: Setup
    
    func setup(withRepository repository: Repository) {
        DispatchQueue.main.async {
            self.accessoryType = .disclosureIndicator
            self.imageView?.image = UIImage(named: "repository-icon")
            
            self.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            self.textLabel?.textColor = UIColor.black
            self.textLabel?.text = repository.name
            
            self.detailTextLabel?.textColor = UIColor.darkGray
            self.detailTextLabel?.text = repository.description
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
