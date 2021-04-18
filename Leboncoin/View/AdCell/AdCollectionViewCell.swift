//  swiftlint:disable identifier_name
//  AdCollectionViewCell.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 17/04/2021.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

final class AdCollectionViewCell: UICollectionViewCell {

    // MARK: - INTERNAL

    // MARK: Properties

    // MARK: Methods

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with ad: Ad, adCategoryStr: String) {
        if let smallImageData = ad.smallImageData { adImageView.image = UIImage(data: smallImageData )
        } else { adImageView.image = UIImage(named: "AdDefaultImage") }
        titleLabel.text = ad.title
        adDescriptionLabel.text = ad.description
        categoryLabel.text = adCategoryStr
        priceLabel.text = "\(ad.price)"
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let adImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    private let adDescriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    private let urgentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.layer.cornerRadius = 20.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .orange
        label.text = "⚠ URGENT"
        return label
    }()

    // MARK: Methods

    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .white

        contentView.addSubview(adImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(adDescriptionLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(urgentLabel)
    }

    //swiftlint:disable line_length
    private func setupLayouts() {
        adImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        adDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        urgentLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `adImageView`
        NSLayoutConstraint.activate([
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])

        // Layout constraints for `titleLabel`
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])

        // Layout constraints for `adDescriptionLabel`
        NSLayoutConstraint.activate([
            adDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            adDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            adDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0)
        ])

        // Layout constraints for `categoryLabel`
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            categoryLabel.topAnchor.constraint(equalTo: adDescriptionLabel.bottomAnchor, constant: 8.0)
        ])

        // Layout constraints for `priceLabel`
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8.0)
        ])

        // Layout constraints for `urgentLabel`
        NSLayoutConstraint.activate([
            urgentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            urgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            urgentLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8.0),
            urgentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.profileDescriptionVerticalPadding)
        ])
    }
    //swiftlint:enable line_lenght

}

extension AdCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)

    }
}

enum Constants {
    // MARK: contentView layout constants
    static let contentViewCornerRadius: CGFloat = 4.0

    // MARK: profileImageView layout constants
    static let imageHeight: CGFloat = 180.0

    // MARK: Generic layout constants
    static let verticalSpacing: CGFloat = 8.0
    static let horizontalPadding: CGFloat = 16.0
    static let profileDescriptionVerticalPadding: CGFloat = 8.0
}
