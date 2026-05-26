//
//  Coordinator.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 26/05/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set}
    
    func start()
}
