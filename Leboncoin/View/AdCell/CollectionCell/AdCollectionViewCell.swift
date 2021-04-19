//  swiftlint:disable identifier_name
//  AdCollectionViewCell.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 17/04/2021.
//

import UIKit

final class AdCollectionViewCell: UICollectionViewCell {

    // MARK: - INTERNAL

    // MARK: Properties

    var isUrgent: Bool = false

    // MARK: Methods

    func setup(with ad: Ad, adCategoryStr: String) {
        if let smallImageData = ad.smallImageData { adImageView.image = UIImage(data: smallImageData )
        } else { adImageView.image = UIImage(named: "AdDefaultImage") }
        titleLabel.text = ad.title
        categoryLabel.text = adCategoryStr
        priceLabel.text = "\(Int(ad.price)) €"
        isUrgent = ad.isUrgent
        setupViews()
        setupLayouts()
    }

    // MARK: LifeCycle methods

    override init(frame: CGRect) {
        super.init(frame: .zero)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
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

    private let categoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let urgentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 12)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .orange
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.orange.cgColor
        label.layer.borderWidth = 1.0
        label.text = " ⚠ URGENT  "
        return label
    }()

    // MARK: Methods

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white

        contentView.addSubview(adImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(priceLabel)

    }

    //swiftlint:disable line_length
    private func setupLayouts() {
        adImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `adImageView`
        NSLayoutConstraint.activate([
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.25)
        ])

        // Layout constraints for `titleLabel`
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])

        // Layout constraints for `priceLabel`
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])

        // Layout constraints for `categoryLabel`
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            categoryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.profileDescriptionVerticalPadding)
        ])

        if isUrgent {
            contentView.addSubview(urgentLabel)
            urgentLabel.translatesAutoresizingMaskIntoConstraints = false

            // Layout constraints for `urgentLabel`
            NSLayoutConstraint.activate([
                urgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                urgentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
            ])
        }
    }
    //swiftlint:enable line_lenght

}

extension AdCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)

    }
}

enum Constants {

    // MARK: profileImageView layout constants
    static let imageHeight: CGFloat = 180.0

    // MARK: Generic layout constants
    static let verticalSpacing: CGFloat = 8.0
    static let horizontalPadding: CGFloat = 16.0
    static let profileDescriptionVerticalPadding: CGFloat = 8.0
}
