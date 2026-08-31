//
//  SettingsView.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var titleOn: Bool
    
    // Задача 4
    @Binding var rowHeight: Double
    @State private var isChanging = false
    
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
                
                Section ("Тема приложения") {
                    Text (
                        colorScheme == .light ? "Light Mode" : "Dark Mode"
                    )
                }
                
                Section("Основные настройки") {
                    
                    Toggle(
                        "Navigation Title",
                        isOn: $titleOn
                    )
                    if titleOn {
                        Text("Navigation Title Включен")
                    }
                    
                    Toggle(
                        "Уведомления",
                        isOn: $notificationsEnabled
                    )
                    
//                    Toggle(
//                        "Тёмная тема",
//                        isOn: $darkModeEnabled
//                    )
//                    
//                    if darkModeEnabled {
//                        Text ("Тёмная тема Включена")
//                    }
//                    else {
//                        Text ("Светлая тема Включена")
//                    }
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
                // Задача 4
                Section("Размепр строки") {
                    Text(
                        "Высота строки: \(Int(rowHeight))"
                    )
                    
                    Slider(
                        value: $rowHeight,
                        in: 90...200,
                        step: 5,
                        onEditingChanged: {editing in
                            isChanging = editing
                        }
                    )
                    if isChanging {
                        InfoRow(
                            post: previewPost,
                            rowHeight: rowHeight)
                    }
                }
                
            }
            .navigationTitle("Настройки")
        }
    }
    // Задача 4
    private var  previewPost: Movies {
        
        let context = PersistenceController.shared.container.viewContext
        
        let movie = Movies(context: context)
        
        movie.title = "Крестный отец"
        movie.genre = "Драма"
        movie.rating = 8.4
        movie.date = 1972
        movie.imageName = "godfather"
        
        return movie
    }
}

#Preview {
    SettingsView(
        titleOn: .constant(true),
        rowHeight: .constant(100)
    )
}


