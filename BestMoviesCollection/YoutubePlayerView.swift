//
//  YoutubePlayerView.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 04/09/26.
//

import SwiftUI
import WebKit

struct YoutubePlayerView: UIViewRepresentable {

    let url: String

    func makeUIView(context: Context) -> WKWebView {

        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true

        let webView = WKWebView(
            frame: .zero,
            configuration: configuration
        )

        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black

        return webView
    }

    func updateUIView(
        _ webView: WKWebView,
        context: Context
    ) {

        guard let videoID = extractYouTubeID(from: url) else {
            return
        }

        let embedURLString =
            "https://www.youtube.com/embed/\(videoID)" +
            "?playsinline=1&rel=0"

        guard let embedURL = URL(
            string: embedURLString
        ) else {
            return
        }

        var request = URLRequest(
            url: embedURL
        )

        // Важно для YouTube Error 153
        if let bundleID = Bundle.main.bundleIdentifier {

            let referer =
                "https://\(bundleID.lowercased())"

            request.setValue(
                referer,
                forHTTPHeaderField: "Referer"
            )
        }

        webView.load(request)
    }

    private func extractYouTubeID(
        from urlString: String
    ) -> String? {

        guard let url = URL(
            string: urlString
        ) else {
            return nil
        }

        // Формат:
        // https://www.youtube.com/watch?v=VIDEO_ID

        if url.host?.contains("youtube.com") == true {

            if let components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            ) {

                if let videoID = components
                    .queryItems?
                    .first(where: {
                        $0.name == "v"
                    })?
                    .value {

                    return videoID
                }
            }

            // Формат:
            // https://www.youtube.com/shorts/VIDEO_ID

            let pathComponents = url.pathComponents

            if let shortsIndex = pathComponents
                .firstIndex(of: "shorts"),
               shortsIndex + 1 < pathComponents.count {

                return pathComponents[
                    shortsIndex + 1
                ]
            }
        }

        // Формат:
        // https://youtu.be/VIDEO_ID

        if url.host?.contains("youtu.be") == true {

            let videoID = url.path
                .trimmingCharacters(
                    in: CharacterSet(
                        charactersIn: "/"
                    )
                )

            return videoID.isEmpty
                ? nil
                : videoID
        }

        return nil
    }
}



#Preview {
    YoutubePlayerView(url: "https://www.youtube.com/watch?v=kgAeKpAPOYk")
}
