//
//  InfoView.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI
import CoreData

struct InfoView: View {
    
    
    
    var titleOn: Bool
    // Задача 4
    var rowHeight: Double
    
    @FetchRequest(
        entity: Movies.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \Movies.rating,
                ascending: false
            ),
            NSSortDescriptor(
                keyPath: \Movies.title,
                ascending: true
            )
        ],
        animation: .default
    )
    private var posts: FetchedResults<Movies>
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                ForEach(posts) { post in
                    
                    NavigationLink {
                        InfoDetails(post: post)
                    } label: {
                        InfoRow(
                            post: post,
                            rowHeight: rowHeight
                        )
                    }
                }
            }
            .navigationTitle(
               titleOn ? "Лучшие фильмы" : "Не только лучшие фильмы"
            )
        }
    }
}

#Preview {
    InfoView(titleOn: true, rowHeight: 100)
}

