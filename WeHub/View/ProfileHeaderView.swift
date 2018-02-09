//
//  ProfileHeaderView.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/7/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Attributes
    
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    var bioLabel = UILabel()
    var locationLabel = UILabel()
    var followersFollowingLabel = UILabel()
    
    // MARK: Initialization
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    
    func setup(withProfile profile: Profile) {        
        profile.fetchAvatarImage { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                    self.avatarImageView.layer.cornerRadius = (self.avatarImageView.frame.size.height / 2)
                }
            }
        }
        
        self.bioLabel.text = profile.bio
        self.locationLabel.text = profile.location
        self.nameLabel.text = "\(profile.name!) (@\(profile.username!))"
        self.followersFollowingLabel.text = "\(profile.following!) following • \(profile.followers!) followers"
    }
    
    func setupUI() {
        // Default padding
        let padding = 10
        
        // Image view
        self.avatarImageView.layer.masksToBounds = false
        self.avatarImageView.clipsToBounds = true
        self.addSubview(self.avatarImageView)
        
        self.avatarImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(padding)
            make.top.equalToSuperview().offset(padding + 5)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        // Name
        self.nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.nameLabel.textColor = UIColor.black
        self.addSubview(self.nameLabel)
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.avatarImageView.snp.trailing).offset(padding)
            make.topMargin.equalTo(self.avatarImageView.snp.top).offset(padding)
        }
        
        // Bio
        self.bioLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.bioLabel.textColor = UIColor.darkGray
        self.addSubview(self.bioLabel)
        
        self.bioLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.avatarImageView.snp.trailing).offset(padding)
            make.topMargin.equalTo(self.nameLabel.snp.bottom).offset(padding)
        }
        
        // Location
        self.locationLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.locationLabel.textColor = UIColor.darkGray
        self.addSubview(self.locationLabel)
        
        self.locationLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.avatarImageView.snp.trailing).offset(padding)
            make.topMargin.equalTo(self.bioLabel.snp.bottom).offset(padding)
        }
        
        // Following
        self.followersFollowingLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.followersFollowingLabel.textColor = UIColor.darkGray
        self.addSubview(self.followersFollowingLabel)
        
        self.followersFollowingLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.avatarImageView.snp.trailing).offset(padding)
            make.topMargin.equalTo(self.locationLabel.snp.bottom).offset(padding)
        }
    }
}
