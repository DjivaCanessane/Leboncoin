//
//  AdCategoryFilterViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 17/04/2021.
//

import UIKit

protocol AdCategoryFilterViewDelegate: AnyObject {
    func pushWhenModalIsDismissed(filteredAdTableViewController: FilteredAdTableViewController)
}

class AdCategoryFilterViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties

    var adCategoriesDict: AdCategoriesDict = [:]
    var ads: Ads = []
    weak var delegate: AdCategoryFilterViewDelegate?

    // MARK: LifeCycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()

        let dismissButton: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissModal)
        )
        self.navigationController?.navigationBar.topItem?.title = navigationTitle
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = dismissButton
    }

    // MARK: Methods

    // MARK: - PRIVATE

    private let navigationTitle: String = "Catégories"

    // MARK: Properties

    private let tableView: UITableView = UITableView()

    // MARK: Methods

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
    }

    @objc
    private func dismissModal() {
        navigationController?.dismiss(animated: true)
    }
}

extension AdCategoryFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategoryID: Int = indexPath.row + 1
        let selectedCategoryName: String = adCategoriesDict[selectedCategoryID] ?? "Inconnu"
        let filteredAds: Ads = ads.filter(categoryID: selectedCategoryID)

        let filteredAdTableViewController: FilteredAdTableViewController = FilteredAdTableViewController()
        filteredAdTableViewController.filteredAds = filteredAds
        filteredAdTableViewController.adCategoriesName = selectedCategoryName

        self.navigationController?.dismiss(animated: true) { [self] in
            delegate?.pushWhenModalIsDismissed(filteredAdTableViewController: filteredAdTableViewController)
        }
    }
}

extension AdCategoryFilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adCategoriesDict.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell()
        tableViewCell.textLabel?.font = .boldSystemFont(ofSize: 18)
        tableViewCell.textLabel?.textColor = .darkGray
        tableViewCell.textLabel?.text = adCategoriesDict[indexPath.row + 1]
        tableViewCell.accessoryType = .disclosureIndicator
        return tableViewCell
    }
}
