//
//  InfoDetails.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI

struct InfoDetails: View {
    
    let post: Movies
    
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
            }
            .padding()
        }
        .navigationTitle("О фильме")
        .navigationBarTitleDisplayMode(.inline)
    }
}



