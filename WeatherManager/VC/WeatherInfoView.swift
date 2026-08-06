//
//  WeatherInfoView.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 05/08/26.
//

import UIKit

final class WeatherInfoView: UIView {

    private let temperatureLabel: UILabel = {
            let label = UILabel()
            label.text = "--°"
            label.font = .systemFont(ofSize: 36, weight: .thin)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()

        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = "Загрузка..."
            label.font = .systemFont(ofSize: 22, weight: .medium)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()

        private let dateLabel: UILabel = {
            let label = UILabel()
            label.text = "-"
            label.font = .systemFont(ofSize: 17)
            label.textColor = UIColor.white.withAlphaComponent(0.8)
            label.textAlignment = .center
            return label
        }()

        // MARK: - Init

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupViews()
            setupConstraints()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func setupViews() {

            [temperatureLabel,
             descriptionLabel,
             dateLabel].forEach {

                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        }

        func setupConstraints() {

            NSLayoutConstraint.activate([

                temperatureLabel.topAnchor.constraint(equalTo: topAnchor),

                temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

                descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8),

                descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

                dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),

                dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

                dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)

            ])
        }
    
    func configure(with weather: CurrentWeatherResponse) {

        temperatureLabel.text = "\(Int(weather.main.temp))°"

        descriptionLabel.text = weather.weather.first?.description.capitalized

        let formatter = DateFormatter()

        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE, d MMMM"

        dateLabel.text = formatter.string(from: Date())
    }

}
