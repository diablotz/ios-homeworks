//
//  InfoDetails.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI
import CoreData

struct InfoDetails: View {
    // следим за объектом Coredata. При изменении счетчика просмотров автоматически поменяется строка
    @ObservedObject var post: Movies
    
    // одно открытие экрана - только одно добавление количества просмотров
    @State private var didCountView = false
    
    // используется для анимации появления строки
    @State private var isVisible = false
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                if let imageName = post.imageName {
                    
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 16
                            )
                        )
                }
                
                Text(post.title ?? "Без названия")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(post.movieDescription ?? "")
                    .font(.body)
                    .lineSpacing(6)
                
                HStack {
                    
                    Label(
                        "IDMb: \(String(format: "%.1f",post.rating) )",
                        systemImage: "star.fill"
                    )
                    
                    Label(
                        "\(post.viewsCount)",
                        systemImage: "eye"
                    )
                    
                   
                    
                }
                
                if let trailerURL = post.trailerURL, !trailerURL.isEmpty {
                    
                    
                    VStack(spacing: 10) {
                        Text("Трейлер")
                            .font(.title)
                            .bold(true)
                        
                        YoutubePlayerView(url: trailerURL)
                            .aspectRatio(
                                16 / 9,
                                contentMode: .fit
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16
                                )
                            )
                        
                
                        }
                    .onAppear {
                        print("Youtube trailer URL: \(trailerURL)")
                    }
            
                }
                else {
                    Text("Трейлер не доступен")
                        .foregroundColor(.secondary)
                }
                
            }
            .padding()
            // начальное состоянии строки - меньше и прозрачнее
            .opacity(isVisible ? 1 : 0.5)
            .scaleEffect(isVisible ? 1 : 0.8)
            // проявление
            .onAppear {
                plusCount() // срабатывание счетчика
                withAnimation (
                    .easeOut(duration: 1.0)
                ) {
                    isVisible = true
                }
            }
        }
//        .onAppear {
//            plusCount()
//        }
        .navigationTitle("О фильме")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // функция увеличения количества просмотров
    private func plusCount() {
        guard !didCountView else {
            return
        }
        
        didCountView = true
        post.viewsCount += 1
        let context = PersistenceController.shared.container.viewContext
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения количества просмотров: \(error.localizedDescription)")
        }
    }
}


