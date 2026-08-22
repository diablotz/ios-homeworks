//
//  FeedViewModelTests.swift
//  NavigationSmplTests
//
//  Created by Timur Zakirov on 22/08/26.
//

import XCTest
import UIKit
import StorageService
@testable import NavigationSmpl

final class FeedViewModelTests: XCTestCase {

    private var viewModel: FeedViewModel!

    override func setUp() {
        super.setUp()

        let model = FeedModel()
        viewModel = FeedViewModel(model: model)
    }

    override func tearDown() {
        viewModel = nil

        super.tearDown()
    }

    // тест - проверка пароля
    // проверка пустого пароля
    func testCheckWithEmptyPassword() {
        
        let result = viewModel.check(passw: "")

        
        XCTAssertEqual(
            result.text,
            "enter_password_key".localized
        )

        XCTAssertEqual(
            result.color,
            UIColor.systemRed
        )
    }
    
    // проверка при вводе правильного пароля
    func testCheckWithCorrectPassword() {
        
        let result = viewModel.check(passw: "Password")

        
        XCTAssertEqual(
            result.text,
            "password_correct_key".localized
        )

        XCTAssertEqual(
            result.color,
            UIColor.green
        )
    }
    
    // проверка при вводе неправильного пароля
    func testCheckWithWrongPassword() {
        
        let result = viewModel.check(passw: "password")

        
        XCTAssertEqual(
            result.text,
            "password_wrong_key".localized
        )

        XCTAssertEqual(
            result.color,
            UIColor.systemRed
        )
    }
    
    // проверка получения поста в зависимости от инднкса
    func testPostAtReturnsPost() {
        
        let post = viewModel.post(at: 0)
        
        XCTAssertEqual(
            post.author,
            postExamples[0].author)
            
    }
}


