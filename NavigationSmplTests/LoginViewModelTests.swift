//
//  LoginViewModelTests.swift
//  NavigationSmplTests
//
//  Created by Timur Zakirov on 22/08/26.
//

import XCTest
@testable import NavigationSmpl

final class LoginViewModelTests: XCTestCase {

    private var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // провека на заполнение полей
    func testIsValidWithEmptyFields() {
        
        let result = viewModel.isValid(
            email: "",
            password: ""
        )

        XCTAssertFalse(result)
    }
    
    // проверка на правильность эмейла
    func testIsValidWithInvalidEmail() {
        
        let result = viewModel.isValid(
            email: "test",
            password: "123456"
        )

        XCTAssertFalse(result)
    }

    // проверка на корректность введенных данныз
    func testIsValidWithCorrectData() {
        
        let result = viewModel.isValid(
            email: "test@example.com",
            password: "123456"
        )

        XCTAssertTrue(result)
    }
}

