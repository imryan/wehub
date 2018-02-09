//
//  GithubHelper.swift
//  WeHub
//
//  Created by Ryan Cohen on 2/6/18.
//  Copyright © 2018 WeWork. All rights reserved.
//

import Foundation

class GitHubHelper {
    
    static let shared = GitHubHelper()
    
    // MARK: User/Repos
    
    func getUserProfile(block: @escaping (_ profile: Profile?) -> ()) {
        let url = endpoint(path: "/users/imryan")
        get(withURL: url) { (data) in
            do {
                guard let data = data else { return }
                let profile = try JSONDecoder().decode(Profile.self, from: data)
                block(profile)
            } catch {
                block(nil)
            }
        }
    }
    
    func getUserRepositories(block: @escaping (_ repositories: [Repository]?) -> ()) {
        let url = endpoint(path: "/users/imryan/repos?sort=pushed")
        get(withURL: url) { (data) in
            do {
                guard let data = data else { return }
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                block(repositories)
            } catch {
                block(nil)
            }
        }
    }
    
    // MARK: Issues
    
    func getIssuesForRepository(_ repository: Repository, block: @escaping (_ issues: [Issue]?) -> ()) {
        let url = endpoint(path: "/repos/imryan/\(repository.name!)/issues?state=all")
        get(withURL: url) { (data) in
            do {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let issues = try decoder.decode([Issue].self, from: data)
                block(issues)
            } catch {
                block(nil)
            }
        }
    }
    
    func createIssue(_ issue: Issue, inRepository repository: Repository, block: @escaping (_ completed: Bool) -> ()) {
        let url = endpoint(path: "/repos/imryan/\(repository.name!)/issues")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(issue)
        request.setValue("token \(Secrets.TOKEN)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, error == nil {
                if response.statusCode == 201 {
                    block(true)
                }
            }
            block(false)
        }.resume()
    }
}

// MARK: Helpers

extension GitHubHelper {
    
    func get(withURL url: URL, block: @escaping (_ data: Data?) -> ()) {
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                block(data)
            }
            block(nil)
        }.resume()
    }
    
    func endpoint(path: String) -> URL {
        let url = "https://api.github.com"
        return URL(string: url.appending(path))!
    }
}
