//
//  APIClient.swift
//  VKApp
//
//  Created by Timur Zakirov on 02/11/26.
//

import Foundation

struct APIClient: Sendable {

    func get<T>(
        url: URL,
        responseType: T.Type
    ) async throws -> T
    where T: Decodable & Sendable {

        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.timeoutInterval = 30

        request.setValue(
            "VKApp/1.0 iOS",
            forHTTPHeaderField: "User-Agent"
        )

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(
                for: request
            )
        } catch {
            throw error
        }

        guard let httpResponse =
                response as? HTTPURLResponse
        else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(
            httpResponse.statusCode
        ) else {
            throw APIError.httpStatus(
                httpResponse.statusCode
            )
        }

        do {
            return try JSONDecoder().decode(
                responseType,
                from: data
            )
        } catch {
            print("Decoding error:", error)
            throw APIError.decoding
        }
    }
}

