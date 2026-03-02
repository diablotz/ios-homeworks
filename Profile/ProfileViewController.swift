//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Timur Zakirov on 02/03/26.
//
import UIKit

class ProfileViewController: UIViewController {

    
    
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
    

    
    

}
