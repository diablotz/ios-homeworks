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
            return ("Введите пароль!", .systemRed)
            
        }
        let isCorrect = model.check(word: passw)
        return isCorrect
        ? ("Пароль введен правильно!", UIColor.green) : ("Пароль неверный!", .systemRed)
        
    }
    
    func post(at index: Int) -> Post {
        postExamples[index]
    }
    
}
