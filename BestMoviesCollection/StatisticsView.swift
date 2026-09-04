//
//  HelloView.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI
import CoreData

struct StatisticsView: View {

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(
                key: "viewsCount",
                ascending: false
            )
        ],
        animation: .default
    )
    private var posts: FetchedResults<Movies>

    @State private var animated = false

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {
                    if let first = posts.first {

                        VStack(spacing: 10) {

                            Image(systemName: "trophy.fill")
                                .font(.system(size: 40))

                            Text("Самый популярный фильм")
                                .font(.headline)

                            Text(first.title ?? "Без названия")
                                .font(.title2)
                                .bold()

                            Label(
                                "\(first.viewsCount) просмотров",
                                systemImage: "eye.fill"
                            )
                            .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(25)
                        .background(.thinMaterial)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                    }



                    Text("Просмотры фильмов")
                        .font(.largeTitle)
                        .bold()

                    Text("Статистика популярности вашей коллекции")
                        .foregroundStyle(.secondary)

                    if posts.isEmpty {

                        ContentUnavailableView(
                            "Нет данных",
                            systemImage: "chart.bar.xaxis",
                            description: Text(
                                "Откройте несколько фильмов, чтобы увидеть статистику."
                            )
                        )

                    } else {

                        VStack(spacing: 16) {

                            ForEach(posts) { post in

                                MovieViewsRow(
                                    post: post,
                                    maxViews: maxViews,
                                    animated: animated
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Статистика")
            .onAppear {
                animated = false

                withAnimation(
                    .easeOut(duration: 0.8)
                ) {
                    animated = true
                }
            }
        }
    }

    private var maxViews: Int64 {

        posts.map(\.viewsCount).max() ?? 1
    }
}

struct MovieViewsRow: View {

    @ObservedObject var post: Movies

    let maxViews: Int64
    let animated: Bool

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            
            
            HStack {

                Text(post.title ?? "Без названия")
                    .font(.headline)
                    .lineLimit(1)

                Spacer()

                Label(
                    "\(post.viewsCount)",
                    systemImage: "eye"
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            GeometryReader { geometry in

                let progress = maxViews > 0
                    ? CGFloat(post.viewsCount) / CGFloat(maxViews)
                    : 0

                ZStack(alignment: .leading) {

                    Capsule()
                        .fill(.secondary.opacity(0.15))
                        .frame(height: 18)

                    Capsule()
                        .fill(.blue)
                        .frame(
                            width: animated
                                ? geometry.size.width * progress
                                : 0,
                            height: 18
                        )
                }
            }
            .frame(height: 18)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}




#Preview {
    StatisticsView()
}
