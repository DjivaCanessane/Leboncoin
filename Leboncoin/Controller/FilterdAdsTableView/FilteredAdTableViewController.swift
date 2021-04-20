//
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

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        title = adCategoriesName
    }

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
}
