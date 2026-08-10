//
//  CityTableViewCell.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 08/08/26.
//

import UIKit

final class CityTableViewCell: UITableViewCell {

    static let reuseID = "CityTableViewCell"

    private let cityLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 20,
            weight: .semibold
        )

        label.textColor = .label

        return label
    }()

    private let temperatureLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 18,
            weight: .medium
        )

        label.textColor = .secondaryLabel

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

    func configure(with weather: CityWeather) {

        cityLabel.text = weather.cityName

        temperatureLabel.text =
            "\(Int(weather.temperature))°"
    }


    func setupUI() {

        backgroundColor = .clear

        selectionStyle = .none

        cityLabel.translatesAutoresizingMaskIntoConstraints = false

        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cityLabel)

        contentView.addSubview(temperatureLabel)

        NSLayoutConstraint.activate([

            cityLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),

            cityLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),

            temperatureLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),

            temperatureLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),

            temperatureLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: cityLabel.trailingAnchor,
                constant: 20
            ),

            contentView.heightAnchor.constraint(
                equalToConstant: 70
            )
        ])
    }
}


