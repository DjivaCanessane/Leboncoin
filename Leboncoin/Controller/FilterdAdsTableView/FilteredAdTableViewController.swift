//  swiftlint:disable identifier_name
//  FilteredAdTableViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 17/04/2021.
//

import UIKit

class FilteredAdTableViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties

    var adCategoriesName: String = ""
    var filteredAds: Ads = []

    // MARK: LifeCycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()

        title = adCategoriesName
    }

    // MARK: Methods

    // MARK: - PRIVATE

    // MARK: Properties

    private let tableView: UITableView = UITableView()

    // MARK: Methods

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = .white
        tableView.register(AdTableViewCell.self, forCellReuseIdentifier: AdTableViewCell.identifier)
    }

    @objc
    private func dismissModal() {
        self.navigationController?.dismiss(animated: true)
    }
}

extension FilteredAdTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adDetailViewController: AdDetailViewController = AdDetailViewController()
        let ad: Ad = filteredAds[indexPath.row]
        adDetailViewController.ad = ad
        adDetailViewController.adDetailCellProvider =
            AdDetailCellProvider(ad: ad, adCategoryName: adCategoriesName)
        navigationController?.pushViewController(adDetailViewController, animated: true)
    }
}

extension FilteredAdTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAds.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: AdTableViewCell.identifier,
            for: indexPath
        ) as? AdTableViewCell ?? AdTableViewCell()

        let ad: Ad = filteredAds[indexPath.row]
        tableViewCell.setup(with: ad)
        return tableViewCell
    }
}
