//
//  LoginViewControllerDelegate.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 07/05/26.
//

import UIKit

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}
