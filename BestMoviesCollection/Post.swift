//
//  Post.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import Foundation
import SwiftUI

struct Post: Identifiable {
    let id: Int
    let title: String
    let description: String
    let image: Image
    let rating: Double
    let genre: String
    let year: Int16
    let viewsCount: Int64
    let trailerURL: String
    
    init (
        id: Int,
        title: String,
        description: String,
        image: Image,
        rating: Double,
        genre: String,
        year: Int16,
        viewsCount: Int64,
        trailerURL: String
        
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.rating = rating
        self.genre = genre
        self.year = year
        self.viewsCount = viewsCount
        self.trailerURL = trailerURL
    }
}
