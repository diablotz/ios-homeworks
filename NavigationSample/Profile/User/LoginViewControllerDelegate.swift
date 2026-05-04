//
//  LoginViewControllerDelegate.swift
//  NavigationSample
//
//  Created by Timur Zakirov on 30/04/26.
//

import UIKit

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}
