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
    let date: Int16
    
    init (
        id: Int,
        title: String,
        description: String,
        image: Image,
        rating: Double,
        genre: String,
        date: Int16
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.rating = rating
        self.genre = genre
        self.date = date
    }
}
