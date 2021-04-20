//  swiftlint:disable line_length identifier_name
//  AdDetailCellProvider.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 19/04/2021.
//

import UIKit

class AdDetailCellProvider {

    // MARK: - INTERNAL

    // MARK: Methods

    init(ad: Ad, adCategoryName: String) {
        self.ad = ad
        self.adCategoryName = adCategoryName
    }

    func getThumbImageCell(adForThumbImage: Ad, width: CGFloat) -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell()
        let contentView = tableViewCell.contentView
        let thumbImageView: UIImageView = UIImageView()

        if let thumbImageData = adForThumbImage.thumbImageData { thumbImageView.image = UIImage(data: thumbImageData)
        } else { thumbImageView.image = UIImage(named: "AdDefaultImage") }

        contentView.addSubview(thumbImageView)
        thumbImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbImageView.heightAnchor.constraint(equalToConstant: width)
        ])
        return tableViewCell
    }

    func getEssentialDetailsCell() -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell()
        let contentView = tableViewCell.contentView

        let titleTextView: UITextView = UITextView()
        addTitle(textView: titleTextView, contentView: contentView)

        let priceLabel: UILabel = UILabel()
        addSellDetails(priceLabel: priceLabel, contentView: contentView, titleTextView: titleTextView)

        let creationDateLabel: UILabel = UILabel()
        addDateDetail(creationDateLabel: creationDateLabel, contentView: contentView, priceLabel: priceLabel)

        return tableViewCell
    }

    func getCategoryCell() -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = adCategoryName
        return tableViewCell
    }

    func getDescriptionCell() -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell()
        let contentView: UIView = tableViewCell.contentView
        let descriptionView: UITextView = UITextView()

        descriptionView.text = ad.description
        descriptionView.isEditable = false
        descriptionView.isSelectable = true

        contentView.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.horizontalPadding),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            descriptionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstant.verticalPadding),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -LayoutConstant.verticalPadding)
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

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.horizontalPadding),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: LayoutConstant.verticalPadding),
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

        contentView.addSubview(siretStackView)
        siretStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            siretStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.horizontalPadding),
            siretStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            siretStackView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: LayoutConstant.verticalPadding)
        ])
    }

    private func addPrice(label: UILabel, contentView: UIView, titleTextView: UIView) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            label.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: LayoutConstant.verticalPadding)
        ])
    }

    private func addDateDetail(creationDateLabel: UILabel, contentView: UIView, priceLabel: UIView) {
        let date: Date = ad.creationDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy à HH:mm"
        creationDateLabel.text = dateFormatter.string(from: date)

        ad.isUrgent ?
            addUrgentStack(creationDateLabel: creationDateLabel, contentView: contentView, priceLabel: priceLabel) :
            addCreationDate(label: creationDateLabel, contentView: contentView, priceLabel: priceLabel)
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

        contentView.addSubview(urgentStackView)
        urgentStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            urgentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.horizontalPadding),
            urgentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            urgentStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: LayoutConstant.verticalPadding)
        ])
    }

    private func addCreationDate(label: UILabel, contentView: UIView, priceLabel: UIView) {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LayoutConstant.horizontalPadding),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LayoutConstant.horizontalPadding),
            label.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: LayoutConstant.verticalPadding)
        ])
    }
}
