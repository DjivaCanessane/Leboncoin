//  swiftlint:disable identifier_name
//  ViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import UIKit

class AdCollectionViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Networking
        populateAds()
        populateAdCategoriesDict()

        // UI
        setupViews()
        setupLayouts()
        self.navigationController?.navigationBar.topItem?.title = "Leboncoin"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = filterButton
    }

    // MARK: Methods

    // MARK: - PRIVATE

    // MARK: Properties

    private var ads: Ads = []
    private var adCategoriesDict: AdCategoriesDict = [:]
    private let adNetworkManager: AdNetworkManager = AdNetworkManager.shared
    private let activityView = UIActivityIndicatorView(style: .large)

    private lazy var filterButton: UIBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .action,
        target: self,
        action: #selector(presentAdCategoriesModally)
    )

    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private enum LayoutConstant {
        static let spacing: CGFloat = 16.0
        static let itemHeight: CGFloat = 300.0
    }

    // MARK: Methods

    @objc
    private func presentAdCategoriesModally() {
        let adCategoryFilterViewController = AdCategoryFilterViewController()
        adCategoryFilterViewController.delegate = self
        adCategoryFilterViewController.adCategoriesDict = adCategoriesDict
        adCategoryFilterViewController.ads = ads
        adCategoryFilterViewController.modalPresentationStyle = .automatic

        present(UINavigationController(rootViewController: adCategoryFilterViewController), animated: true)
    }

    private func populateAds() {
        showActivityIndicatory()
        adNetworkManager.getAds { result in
            switch result {
            case .failure(let networkError): print(networkError)
            case .success(let downloadedAds): self.ads = downloadedAds
                self.collectionView.reloadData()
            }

        }
    }

    private func populateAdCategoriesDict() {
        adNetworkManager.getAdCategoriesDict { result in
            self.activityView.stopAnimating()
            switch result {
            case .failure(let networkError): print(networkError)
            case .success(let downloadedAdCategoriesDict):
                self.adCategoriesDict = downloadedAdCategoriesDict
                self.collectionView.reloadData()
            }

        }
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
    }

    private func showActivityIndicatory() {
        activityView.center = self.view.center
        activityView.color = .darkGray
        activityView.style = .large
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }

    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints for `collectionView`
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

extension AdCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AdCollectionViewCell.identifier,
            for: indexPath
        ) as? AdCollectionViewCell ?? AdCollectionViewCell()

        let ad: Ad = ads[indexPath.row]
        let adCategoryStr: String = adCategoriesDict[ad.categoryID] ?? "Inconnu"
        cell.setup(with: ad, adCategoryStr: adCategoryStr)
        return cell
    }

}

extension AdCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let width = (view.frame.width / 2) - (LayoutConstant.spacing * 2)

        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: LayoutConstant.spacing,
            left: LayoutConstant.spacing,
            bottom: LayoutConstant.spacing,
            right: LayoutConstant.spacing
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return LayoutConstant.spacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return LayoutConstant.spacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let adDetailViewController: AdDetailViewController = AdDetailViewController()
        let ad: Ad = ads[indexPath.row]
        adDetailViewController.ad = ad
        adDetailViewController.adCategoryName = adCategoriesDict[ad.categoryID] ?? "Inconnu"
        navigationController?.pushViewController(adDetailViewController, animated: true)
    }
}

extension AdCollectionViewController: AdCategoryFilterViewDelegate {
    func pushWhenModalIsDismissed(filteredAdTableViewController: FilteredAdTableViewController) {
        self.navigationController?.pushViewController(filteredAdTableViewController, animated: true)
    }
}
