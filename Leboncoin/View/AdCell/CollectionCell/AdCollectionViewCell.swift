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
        if let smallImageData = ad.smallImageData { adImageView.image = UIImage(data: smallImageData)
        } else { adImageView.image = UIImage(named: "AdDefaultImage") }

        titleLabel.text = ad.title
        categoryLabel.text = adCategoryStr
        priceLabel.text = "\(Int(ad.price)) €"
        isUrgent = ad.isUrgent
        setupViews()
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let adImageView: UIImageView = {
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
        label.layer.borderWidth = 1
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

        setupLayouts()
    }

    private func setupLayouts() {
        addAdImageView()
        addLabelStack()
        if isUrgent { addUrgentLabel() }
    }

    //swiftlint:disable line_length
    private func addAdImageView() {
        adImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            adImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.25)
        ])
    }

    private func addLabelStack() {
        let priceCategoryStack = UIStackView(arrangedSubviews: [priceLabel, categoryLabel])
        priceCategoryStack.axis = .vertical
        priceCategoryStack.distribution = .equalCentering
        priceCategoryStack.alignment = .leading

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, priceCategoryStack])
        labelStack.axis = .vertical
        labelStack.distribution = .equalSpacing
        labelStack.alignment = .leading

        contentView.addSubview(labelStack)
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            labelStack.topAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: LayoutConstant.verticalPadding),
            labelStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstant.verticalPadding)
        ])
    }

    private func addUrgentLabel() {
        contentView.addSubview(urgentLabel)
        urgentLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            urgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.verticalPadding),
            urgentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstant.verticalPadding)
        ])
    }
    //swiftlint:enable line_lenght
}

extension AdCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)

    }
}
