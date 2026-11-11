//
//  Error+Cancellation.swift
//  VKApp
//
//  Created by Timur Zakirov on 04/11/26.
//

import Foundation

extension Error {

    var isCancellationError: Bool {
        if self is CancellationError {
            return true
        }

        if let urlError = self as? URLError,
           urlError.code == .cancelled {
            return true
        }

        let nsError = self as NSError

        return nsError.domain == NSURLErrorDomain
            && nsError.code == NSURLErrorCancelled
    }
}

