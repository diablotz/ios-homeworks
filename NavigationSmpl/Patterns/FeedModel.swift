//
//  FeedModel.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 12/05/26.
//

import UIKit

class FeedModel {
    private let secretWord: String = "Password"
    /*
    init(secretWord: String) {
        self.secretWord = secretWord
        super.init()
        check(word: "password")
    }
    required init?(coder: NSCoder) {
        fatalError("lol")
    }
    */
    func check(word: String) -> Bool {
        return word == secretWord
    }
}
