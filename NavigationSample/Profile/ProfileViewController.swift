//
//  ProfileViewController.swift
//  Navigation
//

import UIKit

final class ProfileViewController: UIViewController {
    
    static let headerIdent = "header"
    static let photoIdent = "photo"
    static let postIdent = "post"
    
    private let user: User
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    static var postTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: headerIdent)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: photoIdent)
        table.register(PostTableViewCell.self, forCellReuseIdentifier: postIdent)
        return table
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup section
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user.fullName

        view.backgroundColor = .systemBackground
        print(user.avatar ?? UIImage())
        
        view.addSubview(tableView)
        setupConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func reloadTableView() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - Extensions

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return postExamples.count
        default:
            assertionFailure("no registered section")
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = Self.postTableView.dequeueReusableCell(withIdentifier: Self.photoIdent, for: indexPath) as! PhotosTableViewCell
            return cell
        case 1:
            let cell = Self.postTableView.dequeueReusableCell(withIdentifier: Self.postIdent, for: indexPath) as! PostTableViewCell
            cell.configPostArray(post: postExamples[indexPath.row])
            return cell
        default:
            assertionFailure("no registered section")
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Self.headerIdent) as! ProfileHeaderView
        headerView.fullNameLabel.text = user.fullName
        headerView.statusLabel.text = user.status
        headerView.avatarImageView.image = user.avatar
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 220 : 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: false)
            navigationController?.pushViewController(PhotosViewController(), animated: true)
        case 1:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            if let post = cell as? PostTableViewCell {
                post.incrementPostViewsCounter()
            }
        default:
            assertionFailure("no registered section")
        }
    }
}

