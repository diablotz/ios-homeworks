//
//  FavoriteViewController.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 28/07/26.
//

import UIKit
import CoreData

final class FavoriteViewController: UIViewController {

    weak var coordinator: FavoriteCoordinator?
    private let tableView = UITableView()
    

    private var favoritePosts: [FavoritePost] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                //image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
                image: UIImage(systemName: "magnifyingglass"),
                style: .plain,
                target: self,
                action: #selector(showFilterAlert)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "xmark.circle"),
                style: .plain,
                target: self,
                action: #selector(clearFilter)
            )
        
        ]

        title = "favorite_key".localized
        view.backgroundColor = .systemBackground

        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: "PostCell")

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        favoritePosts = CoreDataManager.shared.fetchPosts()
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        favoritePosts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostCell",
            for: indexPath
        ) as! PostTableViewCell

        let post = favoritePosts[indexPath.row]

        cell.postAuthor.text = post.author
        //cell.postDescription.text = post.description
        //cell.postLikes.text = "Likes: \(post.likes)"
        cell.postLikes.text = "likes_key".getLikesString(Int(post.likes))
        //cell.postViews.text = "Views: \(post.views)"
        cell.postViews.text = "views_key".getViewsString(Int(post.views))

        if let imageName = post.imageName {
            cell.postImage.image = UIImage(named: imageName)
        }

        return cell
    }
    
    @objc private func showFilterAlert() {
        let alert = UIAlertController(
            title: "search_post_key".localized,
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addTextField ()
        
        let aooly = UIAlertAction(
            title: "show_key".localized,
            style: .default
        ) { [weak self] _ in
            guard let author = alert.textFields?.first?.text else { return }
            self?.favoritePosts = CoreDataManager.shared.fetchPosts(author: author)
            
            self?.tableView.reloadData()
        }
        alert.addAction(aooly)
        present(alert, animated: true)
    }
    
    @objc private func clearFilter() {
        favoritePosts = CoreDataManager.shared.fetchPosts()
        tableView.reloadData()
    }
    
    
}
/*
extension FavoriteViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {

        guard editingStyle == .delete else { return }

        let post = favoritePosts[indexPath.row]

        CoreDataManager.shared.deletePost(post: post)

        favoritePosts.remove(at: indexPath.row)

        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
*/
extension FavoriteViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: NSLocalizedString("delete_key", comment: "")
        ) { [weak self] _, _, completion in

            guard let self else { return }
            
            

            let post = favoritePosts[indexPath.row]
            let author = post.author ?? ""

            let alert = UIAlertController(
                title: "alert_key".localized,
                message: "Вы уверены, что хотите удалить пост автора \(author) из избранного?",
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(title: "cancel_key".localized, style: .cancel) {_ in
                completion(false)
            }
            let deleteAction = UIAlertAction(title: "delete_key".localized, style: .destructive) {_ in
                
                CoreDataManager.shared.deletePost(post: post)

                self.favoritePosts.remove(at: indexPath.row)

                tableView.deleteRows(
                    at: [indexPath],
                    with: .automatic
                )
                let alertInfo = UIAlertController(
                    title: "alert_key".localized,
                    message: "Вы удалили пост \(author) из избранного!",
                    preferredStyle: .alert
                )
                alertInfo.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alertInfo, animated: true)
                completion(true)
            }
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true)
            
            
            
            print("Author \(author) deleted")
            
            
            
            //completion(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
