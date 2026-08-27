//
//  PostData.swift
//  BestMoviesCollection
//
//  Created by Timur Zakirov on 27/08/26.
//

import Foundation


struct PostData {
    
    static let posts: [
        (
            title: String,
            description: String,
            imageName: String,
            genre: String,
            rating: Double,
            date: Int16
        )
    ] = [
        
        (
            title: "Побег из Шоушенка",
            description: "Несправедливо осужденный банкир готовит побег из тюрьмы. Тим Роббинс в выдающейся экранизации Стивена Кинга",
            imageName: "shawshank",
            genre: "Драма",
            rating: 9.3,
            date: 1994
            
        ),
        
        (
            title: "Крестный отец",
            description: "В семье крупного нью-йоркского мафиози наметился кризис. Революция в гангстерском кино и начало большого эпоса",
            imageName: "godfather",
            genre: "Драма",
            rating: 9.2,
            date:1972
            
        ),
        
        (
            title: "Крестный отец 2",
            description: "Юность Вито Корлеоне и первые шаги его сына Майкла во главе клана — сразу и приквел, и сиквел. Шесть «Оскаров»",
            imageName: "godfather2",
            genre: "Драма",
            rating: 9.1,
            date:1974
            
        ),
        
        (
            title: "Темный рыцарь",
            description: "«Чё ты такой серьёзный?» Супергеройский блокбастер Кристофера Нолана, который изменил законы жанра",
            imageName: "darkknight",
            genre: "Фантастика",
            rating: 9.0,
            date:2008
            
        ),
        
        (
            title: "Список Шиндлера",
            description: "История немецкого промышленника, спасшего тысячи жизней во время Холокоста. Драма Стивена Спилберга",
            imageName: "schindler",
            genre: "История",
            rating: 8.9,
            date:1993
            
        ),
        
        (
            title: "Властелин колец: Возвращение короля",
            description: "Арагорн штурмует Мордор, а Фродо устал бороться с чарами кольца. Эффектный финал саги, собравший 11 «Оскаров»",
            imageName: "lordofrings3",
            genre: "Фэнтези",
            rating: 8.8,
            date:2003
            
        ),
        
        (
            title: "Криминальное чтиво",
            description: "Несколько связанных историй из жизни бандитов. Шедевр Квентина Тарантино, который изменил мировое кино",
            imageName: "pulpfiction",
            genre: "Боевик",
            rating: 8.7,
            date:1994
            
        ),
        
        (
            title: "Бойцовский клуб",
            description: "Бессонница, драки и мыло. Контркультурный шедевр Дэвида Финчера, который можно пересматривать бесконечно",
            imageName: "fightclub",
            genre: "Драма",
            rating: 8.6,
            date:1999
            
        ),
        (
            title: "Властелин колец: Братство кольца",
            description: "Фродо Бэггинс отправляется спасать Средиземье. Первая часть культовой фэнтези-трилогии Питера Джексона",
            imageName: "lordofrings1",
            genre: "Фэнтези",
            rating: 8.5,
            date:2001
            
        ),
        (
            title: "Форрест Гамп",
            description: "Полувековая история США глазами чудака из Алабамы. Абсолютная классика Роберта Земекиса с Томом Хэнксом",
            imageName: "forrestgump",
            genre: "Драма",
            rating: 8.4,
            date:1994
            
        )
        
    ]
    
}
