//
//  LoginViewModel.swift
//  VKApp
//
//  Created by Timur Zakirov on 24/09/26.
//

import Foundation

final class LoginViewModel {

    struct Content {
        let title: String
        let subtitle: String
        let buttonTitle: String
    }

    let content: Content

    var onSuccess: ((AppUser) -> Void)?
    var onError: ((String) -> Void)?

    private let mode: LoginMode
    private let repository: AuthenticationRepository

    init(
        mode: LoginMode,
        repository: AuthenticationRepository
    ) {
        self.mode = mode
        self.repository = repository

        switch mode {
        case .login:
            self.content = Content(
                title: "С возвращением",
                subtitle: "Введите номер телефона\nдля входа в приложение",
                buttonTitle: "ПОДТВЕРДИТЬ"
            )

        case .registration:
            self.content = Content(
                title: "Регистрация",
                subtitle: "Введите номер телефона\nдля создания аккаунта",
                buttonTitle: "ПРОДОЛЖИТЬ"
            )
        }
    }

    func submit(phone: String) {
        do {
            let user: AppUser

            switch mode {
            case .login:
                user = try repository.login(phone: phone)

            case .registration:
                user = try repository.register(phone: phone)
            }

            onSuccess?(user)
        } catch {
            let message =
                (error as? LocalizedError)?.errorDescription
                ?? "Произошла неизвестная ошибка"

            onError?(message)
        }
    }
}
