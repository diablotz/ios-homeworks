//
//  ContentView.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//



import SwiftUI

struct ContentView: View {
    
    //@State private var titleOn = true
    // Задача 3
    @AppStorage("titleOn") private var titleOn = true
    
    // Задача 4*
    @AppStorage("rowHeight") private var rowHeight: Double = 100
    
    var body: some View {
        
        TabView {
            
            InfoView(
                titleOn: titleOn,
                rowHeight: rowHeight
            )
                .tabItem {
                    Label(
                        "Фильмы",
                        systemImage: "film"
                    )
                }
            
            StatisticsView()
                .tabItem {
                    Label(
                        "Просмотры",
                        systemImage: "chart.bar.xaxis"
                    )
                }
            
            SettingsView(
                titleOn: $titleOn,
                // Задача 4
                rowHeight: $rowHeight
            )
                .tabItem {
                    Label(
                        "Настройки",
                        systemImage: "gearshape"
                    )
                }
        }
    }
}

#Preview {
    ContentView()
}


//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Movies.title, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Movies>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        // Просто выводим название фильма, без форматирования даты
//                        Text("Фильм: \(item.title ?? "Без названия")")
//                    } label: {
//                        // Отображаем название в списке
//                        Text(item.title ?? "Без названия")
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newMovie = Movies(context: viewContext)
//            newMovie.title = "Фильм "
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()


