//  swiftlint:disable identifier_name
//  AdTableViewCell.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 18/04/2021.
//

import UIKit

final class AdTableViewCell: UITableViewCell {

    // MARK: - INTERNAL

    // MARK: Properties

    var isUrgent: Bool = false

    // MARK: Methods

    func setup(with ad: Ad) {
        if let smallImageData = ad.smallImageData { adImageView.image = UIImage(data: smallImageData )
        } else { adImageView.image = UIImage(named: "AdDefaultImage") }
        titleLabel.text = ad.title
        priceLabel.text = "\(Int(ad.price)) €"
        isUrgent = ad.isUrgent
        setupViews()
        setupLayouts()
    }

    // MARK: LifeCycle methods

    // MARK: - PRIVATE

    // MARK: Properties

    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        let contentViewWidth: CGFloat = contentView.bounds.width
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private let urgentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 12)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .orange
        label.text = " ⚠ URGENT  "
        return label
    }()

    // MARK: Methods

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white

        contentView.addSubview(adImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)

    }

    //swiftlint:disable line_length
    private func setupLayouts() {
        adImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `adImageView`
        NSLayoutConstraint.activate([
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            adImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalSpacing),
            adImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing),
            adImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75, constant: 0)
        ])

        // Layout constraints for `titleLabel`
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])

        // Layout constraints for `priceLabel`
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: Constants.horizontalPadding),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0)
        ])

        if isUrgent {
            contentView.addSubview(urgentLabel)
            urgentLabel.translatesAutoresizingMaskIntoConstraints = false

            // Layout constraints for `urgentLabel`
            NSLayoutConstraint.activate([
                urgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
                urgentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing)
            ])
        }
    }
    //swiftlint:enable line_lenght

}

extension AdTableViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
