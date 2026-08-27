//
//  InfoRow.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI

struct InfoRow: View {
    
    let post: Movies
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            if let imageName = post.imageName {
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: 70,
                        height: 100
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
                
                Text("Рейтинг IMDb: " + String(format: "%.1f",post.rating))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
