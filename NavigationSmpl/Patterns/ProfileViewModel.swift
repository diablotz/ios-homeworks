//
//  ProfileViewModel.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 15/05/26.
//

import UIKit
import StorageService

class ProfileViewModel {
    
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    
    var fullName: String {
        user.fullName
    }
    
    var avatar: UIImage? {
        user.avatar
    }
    
    var status: String {
        user.status
    }
    
    var postsCount: Int {
        postExamples.count
    }
    
    func post(at index: Int) -> Post {
        postExamples[index]
    }
    
}
