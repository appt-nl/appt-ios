//
//  KnowledgeViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class KnowledgeViewController: TableViewController {

    @IBOutlet private var filterItem: UIBarButtonItem!
    
    private var posts = [Post]()
    var categories: [Category]?
    var tags: [Tag]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterItem.title = "article_filter".localized
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
        tableView.refreshControl = refreshControl
        
        // Get posts
        getPosts()
    }
    
    @IBAction func doFilter(_ sender: Any) {
        performSegue(.filter, sender: self)
    }
    
    override func refresh(_ refreshControl: UIRefreshControl) {
        posts.removeAll()
        tableView.reloadData()
        
        getPosts()
    }
    
    private func getPosts() {
        if !refreshControl.isRefreshing {
            isLoading = true
        }
        
        API.shared.getArticles(type: .post, categories: categories, tags: tags) { (response) in
            if let posts = response.result {
                self.posts = posts
                self.tableView.reloadData()
            } else if let error = response.error {
                self.showError(error)
            }
            self.refreshControl.endRefreshing()
            self.isLoading = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController, let post = sender as? Post {
            articleViewController.type = post.type
            articleViewController.id = post.id
        } else if let filterViewController = segue.destination as? FilterViewController {
            filterViewController.categories = categories
            filterViewController.tags = tags
        }
    }
    
    @IBAction func applyFilters(_ segue: UIStoryboardSegue) {
        posts.removeAll()
        tableView.reloadData()
        
        getPosts()
    }
}

// MARK: - UITableView

extension KnowledgeViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let post = posts[indexPath.row]
        cell.setup(post.title.decoded)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        performSegue(.article, sender: post)
    }
}
