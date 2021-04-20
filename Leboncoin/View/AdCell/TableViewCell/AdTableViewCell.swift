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
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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

        setupLayouts()
    }

    private func setupLayouts() {
        addAdImageView()
        addTitleLabel()
        addPriceLabel()
        if isUrgent { addUrgentLabel() }
    }

    //swiftlint:disable line_length
    private func addAdImageView() {
        adImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.horizontalPadding),
            adImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstant.verticalPadding),
            adImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstant.verticalPadding),
            adImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75, constant: 0)
        ])
    }

    private func addTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: LayoutConstant.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstant.verticalPadding)
        ])
    }

    private func addPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: LayoutConstant.horizontalPadding),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstant.verticalPadding)
        ])
    }

    private func addUrgentLabel() {
        contentView.addSubview(urgentLabel)
        urgentLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            urgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            urgentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstant.verticalPadding)
        ])
    }
    //swiftlint:enable line_lenght
}

extension AdTableViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
