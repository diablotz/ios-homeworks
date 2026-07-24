//
//  QuoteTableViewCell.swift
//  QuoteDatabase
//
//  Created by Timur Zakirov on 24/07/26.
//

import UIKit

final class QuoteTableViewCell: UITableViewCell {

    static let identifier = "QuoteCell"

    private let quoteLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with joke: Quote) {

        quoteLabel.text = joke.text

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        dateLabel.text = formatter.string(from: joke.createdDate)
    }

    private func setupViews() {

        quoteLabel.numberOfLines = 0
        quoteLabel.font = .systemFont(ofSize: 17)

        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [
            quoteLabel,
            dateLabel
        ])

        stack.axis = .vertical
        stack.spacing = 8

        contentView.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
