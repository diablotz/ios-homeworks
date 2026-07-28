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

        title = "Избранное"
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
        cell.postLikes.text = "Likes: \(post.likes)"
        cell.postViews.text = "Views: \(post.views)"

        if let imageName = post.imageName {
            cell.postImage.image = UIImage(named: imageName)
        }

        return cell
    }
}

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
