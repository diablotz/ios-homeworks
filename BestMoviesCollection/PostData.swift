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
            year: Int16,
            trailerURL: String
        )
    ] = [
        
        (
            title: "Побег из Шоушенка",
            description: "Несправедливо осужденный банкир готовит побег из тюрьмы. Тим Роббинс в выдающейся экранизации Стивена Кинга",
            imageName: "shawshank",
            genre: "Драма",
            rating: 9.3,
            year: 1994,
            trailerURL: "https://www.youtube.com/watch?v=kgAeKpAPOYk"
            
        ),
        
        (
            title: "Крестный отец",
            description: "В семье крупного нью-йоркского мафиози наметился кризис. Революция в гангстерском кино и начало большого эпоса",
            imageName: "godfather",
            genre: "Драма",
            rating: 9.2,
            year:1972,
            trailerURL: "https://www.youtube.com/watch?v=E3b9jVCUh7Q"
        ),
        
        (
            title: "Крестный отец 2",
            description: "Юность Вито Корлеоне и первые шаги его сына Майкла во главе клана — сразу и приквел, и сиквел. Шесть «Оскаров»",
            imageName: "godfather2",
            genre: "Драма",
            rating: 9.1,
            year:1974,
            trailerURL: "https://www.youtube.com/watch?v=oQgTfIlAN64"
        ),
        
        (
            title: "Темный рыцарь",
            description: "«Чё ты такой серьёзный?» Супергеройский блокбастер Кристофера Нолана, который изменил законы жанра",
            imageName: "darkknight",
            genre: "Фантастика",
            rating: 9.0,
            year:2008,
            trailerURL: "https://www.youtube.com/watch?v=HF1_epZNoCg"
        ),
        
        (
            title: "Список Шиндлера",
            description: "История немецкого промышленника, спасшего тысячи жизней во время Холокоста. Драма Стивена Спилберга",
            imageName: "schindler",
            genre: "История",
            rating: 8.9,
            year:1993,
            trailerURL: "https://www.youtube.com/watch?v=4r2Z0U9Y53o"
        ),
        
        (
            title: "Властелин колец: Возвращение короля",
            description: "Арагорн штурмует Мордор, а Фродо устал бороться с чарами кольца. Эффектный финал саги, собравший 11 «Оскаров»",
            imageName: "lordofrings3",
            genre: "Фэнтези",
            rating: 8.8,
            year:2003,
            trailerURL: "https://www.youtube.com/watch?v=lxAeV1-KpSA"
        ),
        
        (
            title: "Криминальное чтиво",
            description: "Несколько связанных историй из жизни бандитов. Шедевр Квентина Тарантино, который изменил мировое кино",
            imageName: "pulpfiction",
            genre: "Боевик",
            rating: 8.7,
            year:1994,
            trailerURL: "https://www.youtube.com/watch?v=vBADUmfa9Q4"
        ),
        
        (
            title: "Бойцовский клуб",
            description: "Бессонница, драки и мыло. Контркультурный шедевр Дэвида Финчера, который можно пересматривать бесконечно",
            imageName: "fightclub",
            genre: "Драма",
            rating: 8.6,
            year:1999,
            trailerURL: "https://www.youtube.com/watch?v=C7-7qQ61QHU"
        ),
        (
            title: "Властелин колец: Братство кольца",
            description: "Фродо Бэггинс отправляется спасать Средиземье. Первая часть культовой фэнтези-трилогии Питера Джексона",
            imageName: "lordofrings1",
            genre: "Фэнтези",
            rating: 8.5,
            year:2001,
            trailerURL: "https://www.youtube.com/watch?v=RNksw9VU2BQ"
        ),
        (
            title: "Форрест Гамп",
            description: "Полувековая история США глазами чудака из Алабамы. Абсолютная классика Роберта Земекиса с Томом Хэнксом",
            imageName: "forrestgump",
            genre: "Драма",
            rating: 8.4,
            year:1994,
            trailerURL: "https://www.youtube.com/watch?v=otmeAaifX04"
        )
        
    ]
    
}
