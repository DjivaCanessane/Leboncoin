//  swiftlint:disable line_length identifier_name
//  AdDetailView.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 19/04/2021.
//

import UIKit

// MARK: Cells layout

class AdDetailCellProvider {

    // MARK: - INTERNAL

    // MARK: Properties

    // MARK: Methods

    init(ad: Ad, adCategoryName: String) {
        self.ad = ad
        self.adCategoryName = adCategoryName
    }

    func getThumbImageCell(tableViewCell: UITableViewCell, adForThumbImage: Ad, width: CGFloat) -> UITableViewCell {
        let thumbImageView: UIImageView = UIImageView()
        let contentView = tableViewCell.contentView

        if let thumbImageData = adForThumbImage.thumbImageData { thumbImageView.image = UIImage(data: thumbImageData)
        } else { thumbImageView.image = UIImage(named: "AdDefaultImage") }

        tableViewCell.contentView.addSubview(thumbImageView)
        thumbImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbImageView.heightAnchor.constraint(equalToConstant: width)
        ])
        return tableViewCell
    }

    func getEssentialDetailsCell(tableViewCell: UITableViewCell) -> UITableViewCell {
        let contentView = tableViewCell.contentView

        let titleTextView: UITextView = UITextView()
        addTitle(textView: titleTextView, contentView: contentView)

        let priceLabel: UILabel = UILabel()
        addSellDetails(priceLabel: priceLabel, contentView: contentView, titleTextView: titleTextView)

        let creationDateLabel: UILabel = UILabel()
        addDateDetail(creationDateLabel: creationDateLabel, contentView: contentView, priceLabel: priceLabel)

        return tableViewCell
    }

    func getCategoryCell(tableViewCell: UITableViewCell) -> UITableViewCell {
        tableViewCell.textLabel?.text = adCategoryName
        return tableViewCell
    }

    func getDescriptionCell(tableViewCell: UITableViewCell) -> UITableViewCell {
        //let tableViewCell: UITableViewCell = UITableViewCell()
        let contentView: UIView = tableViewCell.contentView
        let textView: UITextView = UITextView()

        textView.text = ad.description
        textView.isEditable = false
        textView.isSelectable = true

        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `textView`
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.profileDescriptionVerticalPadding),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.profileDescriptionVerticalPadding)
        ])

        return tableViewCell
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let ad: Ad
    private let adCategoryName: String

    // MARK: Methods

    private func addTitle(textView: UITextView, contentView: UIView) {
        textView.text = ad.title
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = .boldSystemFont(ofSize: 24)

        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `titleTextView`
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.profileDescriptionVerticalPadding),
            textView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func addSellDetails(priceLabel: UILabel, contentView: UIView, titleTextView: UIView) {
        priceLabel.text = "\(Int(ad.price)) €"
        priceLabel.textColor = .orange
        priceLabel.font = .boldSystemFont(ofSize: 18)

        if let siret = ad.siret {
            addSiretStack(siret: siret, priceLabel: priceLabel, contentView: contentView, titleTextView: titleTextView)
        } else {
            addPrice(label: priceLabel, contentView: contentView, titleTextView: titleTextView)
        }

    }

    private func addSiretStack(siret: String, priceLabel: UIView, contentView: UIView, titleTextView: UIView) {
        let siretLabel: UILabel = UILabel()

        siretLabel.text = "SIRET: \(siret)"

        let siretStackView = UIStackView(arrangedSubviews: [priceLabel, siretLabel])
        siretStackView.axis = .horizontal
        siretStackView.distribution = .equalSpacing
        siretStackView.alignment = .leading
        siretStackView.spacing = 30.0

        contentView.addSubview(siretStackView)
        siretStackView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `siretStackView`
        NSLayoutConstraint.activate([
            siretStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            siretStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            siretStackView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])
    }

    private func addPrice(label: UILabel, contentView: UIView, titleTextView: UIView) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `priceLabel`
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            label.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])
    }

    private func addDateDetail(creationDateLabel: UILabel, contentView: UIView, priceLabel: UIView) {
        let date: Date = ad.creationDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy à HH:mm"
        creationDateLabel.text = dateFormatter.string(from: date)

        if ad.isUrgent {
            addUrgentStack(creationDateLabel: creationDateLabel, contentView: contentView, priceLabel: priceLabel)
        } else {
            addCreationDate(label: creationDateLabel, contentView: contentView, priceLabel: priceLabel)
        }
    }

    private func addUrgentStack(creationDateLabel: UILabel, contentView: UIView, priceLabel: UIView) {
        let urgentLabel: UILabel = UILabel()

        urgentLabel.layer.cornerRadius = 8
        urgentLabel.layer.masksToBounds = true
        urgentLabel.textAlignment = .center
        urgentLabel.textColor = .white
        urgentLabel.backgroundColor = .orange
        urgentLabel.text = "⚠ URGENT"

        let urgentStackView = UIStackView(arrangedSubviews: [creationDateLabel, urgentLabel])
        urgentStackView.axis = .horizontal
        urgentStackView.distribution = .fillProportionally
        urgentStackView.alignment = .leading
        urgentStackView.spacing = 30.0

        contentView.addSubview(urgentStackView)
        urgentStackView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `urgentStackView`
        NSLayoutConstraint.activate([
            urgentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            urgentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            urgentStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])
    }

    private func addCreationDate(label: UILabel, contentView: UIView, priceLabel: UIView) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `creationDateLabel`
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            label.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])
    }
}
