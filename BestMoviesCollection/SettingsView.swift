//
//  SettingsView.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var selectedGenre = "Все"
    @State private var rating = 8.0
    
    let genres = [
        "Все",
        "Биография",
        "Боевик",
        "Драма",
        "История",
        "Комедия",
        "Триллер",
        "Фантастика",
        "Фэнтези"
    ]
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Основные настройки") {
                    
                    Toggle(
                        "Уведомления",
                        isOn: $notificationsEnabled
                    )
                    
                    Toggle(
                        "Тёмная тема",
                        isOn: $darkModeEnabled
                    )
                }
                
                Section("Фильмы") {
                    
                    Picker(
                        "Жанр",
                        selection: $selectedGenre
                    ) {
                        
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        
                        Text(
                            "Минимальный рейтинг: \(rating, specifier: "%.1f")"
                        )
                        
                        Slider(
                            value: $rating,
                            in: 0...10,
                            step: 0.1
                        )
                    }
                }
            }
            .navigationTitle("Настройки")
        }
    }
}

#Preview {
    SettingsView()
}


