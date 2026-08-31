//
//  InfoRow.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI

struct InfoRow: View {
    
    let post: Movies
    
    // Задача 4
    var rowHeight: Double
    
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
                
                Text("Год выхода:   \(post.date)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Жанр: \(post.genre ?? "")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Рейтинг IMDb: " + String(format: "%.1f",post.rating))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
