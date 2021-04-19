//  swiftlint:disable identifier_name
//  AdDetailViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 18/04/2021.
//

import UIKit

class AdDetailViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties

    var ad: Ad!
    var adDetailCellProvider: AdDetailCellProvider!

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        getThumbImage()
        configureTableView()
        title = "Détails"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    // MARK: Methods

    // MARK: - PRIVATE

    // MARK: Properties

    private var tableView: UITableView = UITableView()
    private let adNetworkManager: AdNetworkManager = AdNetworkManager.shared

    // MARK: Methods

    private func getThumbImage() {
        adNetworkManager.getThumbImage(for: ad) { [weak self] in
            guard let self = self else { return }
            self.ad.thumbImageData = $0
            self.tableView.reloadData()
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

}

extension AdDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
