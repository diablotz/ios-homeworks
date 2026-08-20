//
//  FeedViewModel.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 15/05/26.
//

import UIKit
import StorageService

final class FeedViewModel {
    private let model: FeedModel
    
    init(model: FeedModel) {
        self.model = model
    }
    
    func check(passw: String?) ->(text: String, color: UIColor) {
        guard let passw, !passw.isEmpty else {
            return ("enter_password_key".localized, .systemRed)
            
        }
        let isCorrect = model.check(word: passw)
        return isCorrect
        ? ("password_correct_key".localized, UIColor.green) : ("password_wrong_key".localized, .systemRed)
        
    }
    
    func post(at index: Int) -> Post {
        postExamples[index]
    }
    
}
