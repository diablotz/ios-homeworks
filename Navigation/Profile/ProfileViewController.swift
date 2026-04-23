//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Timur Zakirov on 02/03/26.
//
import UIKit

class ProfileViewController: UIViewController {
    // код из ДЗ №3
    private lazy var headerView: ProfileHeaderView = {
        let header = ProfileHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
        
    }()
    
    private lazy var newButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться в Ленту", for: .normal)
        button.addTarget(self, action: #selector(go2Feed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.tintColor = .white
        button.layer.cornerRadius = 20
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        #if DEBUG
        view.backgroundColor = .black
        #else
        view.backgroundColor = .green
        #endif
        //view.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(newButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            // profileHeaderView
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),
            
            // кнопка NewButton
            newButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            newButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            newButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -110),
            newButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func go2Feed() {
        let feedVC = FeedViewController()
        self.navigationController?.pushViewController(feedVC, animated: true)
    }
    /*
    @objc func closeProfile() {
        exit(0)
        //self.navigationController?.popViewController(animated: true)
    }
    */
    // код из ДЗ №2
 /*
    let headerView = ProfileHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        view.backgroundColor = .white
        
        view.addSubview(headerView)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //headerView.backgroundColor = .red
        headerView.frame = CGRect (
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.bounds.width,
            height: view.bounds.height - view.safeAreaInsets.top
        )
    }
*/

    
    

}
