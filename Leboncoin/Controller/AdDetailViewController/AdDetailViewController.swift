//  swiftlint:disable identifier_name
//  AdDetailViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 18/04/2021.
//

import UIKit

extension AdDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension AdDetailViewController: UITableViewDataSource {

    // MARK: - Section methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return AdDetailSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOFRowInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        guard let adDetailSection = AdDetailSection(rawValue: section) else { return nil }

        let headerTitleLabel: UILabel = UILabel()
        headerTitleLabel.textColor = .black
        headerTitleLabel.font = .boldSystemFont(ofSize: 22)

        switch adDetailSection {
        case .thumbImage: return nil
        case .essantialsDetails: return nil
        case .category: headerTitleLabel.text = adDetailSection.description
        case .description: headerTitleLabel.text = adDetailSection.description
        }

        headerView.addSubview(headerTitleLabel)

        // headerTitleLabel Constraints
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerTitleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let adDetailSection = AdDetailSection(rawValue: section) else { return .zero }

        switch adDetailSection {
        case .thumbImage: return .zero
        case .essantialsDetails: return .zero
        case .category: return 36.0
        case .description: return 36.0
        }
    }

    // MARK: - Row methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let adDetailSection = AdDetailSection(rawValue: indexPath.section) else { return .zero }

        switch adDetailSection {
        case .thumbImage: return 320
        case .essantialsDetails: return 160
        case .category: return 30
        case .description: return 100
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        guard let adDetailSection = AdDetailSection(rawValue: indexPath.section) else { return tableViewCell }

        switch adDetailSection {
        case .thumbImage: return getThumbImageCell(tableViewCell)
        case .essantialsDetails: return getEssentialDetailsCell(tableViewCell)
        case .category:
            tableViewCell.textLabel?.text = adCategoryName
            return tableViewCell
        case .description: return getDescriptionCell(tableViewCell)
        }
    }
}

class AdDetailViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties

    var ad: Ad!
    var adCategoryName: String = ""

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        getThumbImage()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    // MARK: Methods

    // MARK: - PRIVATE

    // MARK: Properties

    private var tableView: UITableView = UITableView()
    private let adNetworkManager: AdNetworkManager = AdNetworkManager.shared

    // MARK: Methods

    private func getThumbImage() {
        adNetworkManager.getThumbImage(for: ad) { [self] in
            ad.thumbImageData = $0
            tableView.reloadData()
        }
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false

        view.addSubview(tableView)
        tableView.frame = view.frame

        tableView.tableFooterView = UIView()
    }

    private func configureUI() {
        configureTableView()
        navigationController?.navigationBar.topItem?.title = "Détails"
    }

    private func getThumbImageCell(_ tableViewCell: UITableViewCell) -> UITableViewCell {
        let thumbImageView: UIImageView = UIImageView()

        if let thumbImageData = ad.thumbImageData { thumbImageView.image = UIImage(data: thumbImageData)
        } else { thumbImageView.image = UIImage(named: "AdDefaultImage") }

        tableViewCell.contentView.addSubview(thumbImageView)
        thumbImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: tableViewCell.contentView.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: tableViewCell.contentView.trailingAnchor),
            thumbImageView.topAnchor.constraint(equalTo: tableViewCell.contentView.topAnchor),
            thumbImageView.heightAnchor.constraint(equalToConstant: 320)
        ])
        return tableViewCell
    }

    private func getEssentialDetailsCell(_ tableViewCell: UITableViewCell) -> UITableViewCell {
        let contentView = tableViewCell.contentView
        let titleLabel: UILabel = UILabel()
        let priceLabel: UILabel = UILabel()
        let creationDateLabel: UILabel = UILabel()

        //let siretLabel: UILabel = UILabel()

        titleLabel.text = ad.title
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 24)

        priceLabel.text = "\(Int(ad.price)) €"
        priceLabel.textColor = .orange
        priceLabel.font = .boldSystemFont(ofSize: 18)

        let date: Date = ad.creationDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy à HH:mm"
        creationDateLabel.text = dateFormatter.string(from: date)

        tableViewCell.contentView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        //swiftlint:disable line_length
        // Layout constraints for `titleLabel`
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.profileDescriptionVerticalPadding)
        ])

        if let siret = ad.siret {
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
                siretStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
            ])
        } else {
            tableViewCell.contentView.addSubview(priceLabel)
            priceLabel.translatesAutoresizingMaskIntoConstraints = false

            // Layout constraints for `priceLabel`
            NSLayoutConstraint.activate([
                priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
                priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
                priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
            ])
        }

        if ad.isUrgent {
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
        } else {
            tableViewCell.contentView.addSubview(creationDateLabel)
            creationDateLabel.translatesAutoresizingMaskIntoConstraints = false

            // Layout constraints for `creationDateLabel`
            NSLayoutConstraint.activate([
                creationDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
                creationDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
                creationDateLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.profileDescriptionVerticalPadding)
            ])
        }
        //swiftlint:enable line_lenght

        return tableViewCell
    }

    private func getDescriptionCell(_ tableViewCell: UITableViewCell) -> UITableViewCell {
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

}
