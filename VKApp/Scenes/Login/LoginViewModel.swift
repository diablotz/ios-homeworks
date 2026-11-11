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
                title: L10n.string("login.welcome_back"),
                subtitle: L10n.string("login.enter_number"),
                buttonTitle: L10n.string("login.confirm")
            )

        case .registration:
            self.content = Content(
                title: L10n.string("login.registration"),
                subtitle: L10n.string("login.create_account"),
                buttonTitle: L10n.string("login.continue")
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
                ?? L10n.string("error.unknown_error")

            onError?(message)
        }
    }
}
