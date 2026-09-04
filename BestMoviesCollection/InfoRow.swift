//
//  InfoRow.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI

struct InfoRow: View {
    
    // следим за объектом Coredata. При изменении счетчика просмотров автоматически поменяется строка
    @ObservedObject var post: Movies
    
    // Задача 4
    var rowHeight: Double
    
    // используется для анимации появления строки
    @State private var isVisible = false
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            if let imageName = post.imageName {
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        // Задача 4
                        width: rowHeight * 0.7,
                        height: rowHeight
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 10
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(post.title ?? "Без названия")
                    .font(.headline)
                
                Text("Год выхода:   \(post.year)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Жанр: \(post.genre ?? "")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
//                Text("Рейтинг IMDb: " + String(format: "%.1f",post.rating) + " Просмотров: \(post.viewsCount)")
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
                HStack(spacing: 20) {
                    Label("\(String(format: "%.1f",post.rating))", systemImage: "star.fill")
                        .foregroundStyle(.secondary)
                    //Text("")
                    Label(" \(post.viewsCount)", systemImage: "eye.fill")
                        .foregroundStyle(.secondary)
                   // Text("")
                }
                .font(.subheadline)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
        
        // начальное состоянии строки - меньше и прозрачнее
        .opacity(isVisible ? 1 : 0.5)
        .scaleEffect(isVisible ? 1 : 0.8)
        // проявление
        .onAppear {
            withAnimation (
                .easeOut(duration: 1.0)
            ) {
                isVisible = true
            }
        }
    }
}
