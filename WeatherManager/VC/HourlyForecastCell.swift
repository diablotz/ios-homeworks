////
////  HourlyForecastCell.swift
////  WeatherManager
////
////  Created by Timur Zakirov on 07/08/26.
////
//

import UIKit

final class HourlyForecastCell: UITableViewCell {

    static let reuseID = "HourlyForecastCell"

    

    private let timeLabel: UILabel = {

        let label = UILabel()

        label.textColor = .white

        label.font = .systemFont(
            ofSize: 18,
            weight: .medium
        )

        return label
    }()

    private let iconImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.tintColor = .white

        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let descriptionLabel: UILabel = {

        let label = UILabel()

        label.textColor = .white

        label.font = .systemFont(
            ofSize: 16
        )

        return label
    }()

    private let temperatureLabel: UILabel = {

        let label = UILabel()

        label.textColor = .white

        label.font = .systemFont(
            ofSize: 22,
            weight: .bold
        )

        label.textAlignment = .right

        return label
    }()

    private let humidityLabel: UILabel = {

        let label = UILabel()

        label.textColor = .white.withAlphaComponent(0.8)

        label.font = .systemFont(
            ofSize: 14
        )

        return label
    }()

    private let windLabel: UILabel = {

        let label = UILabel()

        label.textColor = .white.withAlphaComponent(0.8)

        label.font = .systemFont(
            ofSize: 14
        )

        return label
    }()

    

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {

        fatalError(
            "init(coder:) has not been implemented"
        )
    }

    

    func configure(with forecast: HourlyForecast) {

        timeLabel.text = forecast.time

        temperatureLabel.text =
            "\(Int(forecast.temperature))°"

        descriptionLabel.text =
            forecast.description.capitalized

        humidityLabel.text =
            "💧 \(forecast.humidity)%"

        windLabel.text =
            "💨 \(String(format: "%.1f", forecast.windSpeed)) м/с"

        iconImageView.image = UIImage(
            systemName: iconName(
                forecast.icon
            )
        )
    }

    func setupUI() {

        backgroundColor = .clear

        selectionStyle = .none

        [
            timeLabel,
            iconImageView,
            descriptionLabel,
            temperatureLabel,
            humidityLabel,
            windLabel
        ].forEach {

            $0.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([

            // Время

            timeLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),

            timeLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),

            timeLabel.widthAnchor.constraint(
                equalToConstant: 55
            ),

            // Иконка

            iconImageView.leadingAnchor.constraint(
                equalTo: timeLabel.trailingAnchor,
                constant: 10
            ),

            iconImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),

            iconImageView.widthAnchor.constraint(
                equalToConstant: 40
            ),

            iconImageView.heightAnchor.constraint(
                equalToConstant: 40
            ),

            // Описание

            descriptionLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: 12
            ),

            descriptionLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),

            // Влажность

            humidityLabel.leadingAnchor.constraint(
                equalTo: descriptionLabel.leadingAnchor
            ),

            humidityLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),

            // Ветер

            windLabel.leadingAnchor.constraint(
                equalTo: humidityLabel.trailingAnchor,
                constant: 12
            ),

            windLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),

            // Температура

            temperatureLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),

            temperatureLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),

            temperatureLabel.widthAnchor.constraint(
                equalToConstant: 65
            ),

            // Описание не должно залезать на температуру

            descriptionLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: temperatureLabel.leadingAnchor,
                constant: -10
            )
        ])
    }

    func iconName(_ icon: String) -> String {

        switch icon {

        case "01d":
            return "sun.max.fill"

        case "01n":
            return "moon.stars.fill"

        case "02d":
            return "cloud.sun.fill"

        case "02n":
            return "cloud.moon.fill"

        case "03d", "03n":
            return "cloud.fill"

        case "04d", "04n":
            return "cloud.fill"

        case "09d", "09n":
            return "cloud.drizzle.fill"

        case "10d", "10n":
            return "cloud.rain.fill"

        case "11d", "11n":
            return "cloud.bolt.rain.fill"

        case "13d", "13n":
            return "snowflake"

        case "50d", "50n":
            return "cloud.fog.fill"

        default:
            return "cloud.fill"
        }
    }
}

