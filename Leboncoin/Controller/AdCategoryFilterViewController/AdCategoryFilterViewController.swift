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

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()

        let dismissButton: UIBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissModal)
        )
        navigationController?.navigationBar.topItem?.title = "Catégories"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = dismissButton
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
        tableView.tableFooterView = UIView()
    }

    @objc
    private func dismissModal() {
        navigationController?.dismiss(animated: true)
    }
}
