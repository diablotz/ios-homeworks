//
//  DateCell.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 10/08/26.
//

import UIKit

final class DateCell: UICollectionViewCell {
    static let reuseID = "DateCell"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with date: Date, isSelected: Bool) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd/MM E"
        
        let text = formatter.string(from: date).uppercased()
        dateLabel.text = text
        
        if isSelected {
            backgroundColor = UIColor.blue
            dateLabel.textColor = .white
        } else {
            backgroundColor = .clear
            dateLabel.textColor = .black
        }
    }
}
