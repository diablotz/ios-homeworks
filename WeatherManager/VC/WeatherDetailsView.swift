//
//  WeatherDetailsView.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 05/08/26.
//

import UIKit

final class WeatherDetailsView: UIView {

    private let humidityView = WeatherDetailCardView()
    private let windView = WeatherDetailCardView()
    private let rainView = WeatherDetailCardView()
    private let daylightView = WeatherDetailCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {

            let topStack = UIStackView(arrangedSubviews: [
                humidityView,
                windView
            ])

            let bottomStack = UIStackView(arrangedSubviews: [
                rainView,
                daylightView
            ])

            [topStack, bottomStack].forEach {

                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.spacing = 12
                $0.translatesAutoresizingMaskIntoConstraints = false
                

                addSubview($0)
            }

            NSLayoutConstraint.activate([

                topStack.topAnchor.constraint(equalTo: topAnchor),
                topStack.leadingAnchor.constraint(equalTo: leadingAnchor),
                topStack.trailingAnchor.constraint(equalTo: trailingAnchor),

                bottomStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 12),
                bottomStack.leadingAnchor.constraint(equalTo: leadingAnchor),
                bottomStack.trailingAnchor.constraint(equalTo: trailingAnchor),
                bottomStack.bottomAnchor.constraint(equalTo: bottomAnchor),

                humidityView.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    
    func configure(with weather: CurrentWeatherResponse) {
        
        humidityView.configure(
            title: "Влажность",
            value:  "\(weather.main.humidity)%"
        )
        
        windView.configure(
            title: "Ветер",
            value: String(format: "%.1f м/с", weather.wind.speed)
        )
        
        rainView.configure(
            title: "Осадки",
            value: "--"
        )
        
        daylightView.configure(
            title: "Световой день",
            value: "__"
        )
        
    }
    
}
