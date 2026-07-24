//
//  Coordinator.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set}
    
    func start()
}
