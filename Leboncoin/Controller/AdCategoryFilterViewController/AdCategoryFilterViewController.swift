//
//  AdCategoryFilterViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 17/04/2021.
//

import UIKit

final class AdCategoryFilterViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties

    var adCategoriesDict: AdCategoriesDict = [:]
    var adCategoryFilterDelegateHandler: AdCategoryFilterDelegateHandler!

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

    // MARK: - PRIVATE

    // MARK: Properties

    private let tableView: UITableView = UITableView()
    private lazy var adCategoryFilterDataSource: AdCategoryFilterDataSource =
        AdCategoryFilterDataSource(adCategoriesDict: adCategoriesDict)

    // MARK: Methods

    private func setUpTableView() {

        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.delegate = adCategoryFilterDelegateHandler
        tableView.dataSource = adCategoryFilterDataSource

        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
    }

    @objc
    private func dismissModal() {
        navigationController?.dismiss(animated: true)
    }
}
