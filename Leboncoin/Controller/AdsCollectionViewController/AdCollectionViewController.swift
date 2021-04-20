//
//  AdCollectionViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import UIKit

final class AdCollectionViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties

    var ads: Ads = []
    var adCategoriesDict: AdCategoriesDict = [:]

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Networking
        fetchAds()
        fetchAdCategoriesDict()

        // UI
        setupViews()
        setupLayouts()
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let adNetworkManager: AdNetworkManager = AdNetworkManager.shared
    private let activityView = UIActivityIndicatorView()

    private lazy var filterButton: UIBarButtonItem = UIBarButtonItem(
        image: UIImage(named: "filter-icon"),
        style: .plain,
        target: self,
        action: #selector(presentAdCategoriesModally)
    )

    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // MARK: Methods

    private func setupViews() {
        view.backgroundColor = .white
        title = "Annonces"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = filterButton
        view.addSubview(collectionView)

        collectionView.dataSource = adCollectionDataSource
        collectionView.delegate = adCollectionDelegateHandler
        collectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
    }

    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    @objc
    private func presentAdCategoriesModally() {
        let adCategoryFilterViewController = AdCategoryFilterViewController()
        adCategoryFilterViewController.adCategoryFilterDelegateHandler = AdCategoryFilterDelegateHandler(
            adCategoriesDict: adCategoriesDict,
            ads: ads,
            navigationController: navigationController
        )
        adCategoryFilterViewController.adCategoryFilterDelegateHandler.delegate = self
        adCategoryFilterViewController.adCategoriesDict = adCategoriesDict
        adCategoryFilterViewController.modalPresentationStyle = .overCurrentContext

        present(UINavigationController(rootViewController: adCategoryFilterViewController), animated: true)
    }

    private func fetchAds() {
        showActivityIndicatory()
        adNetworkManager.getAdsData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let networkError): self.showErrorAlert(message: networkError.message)
            case .success(let downloadedAdsData):
                self.adNetworkManager.getSmallImage(for: downloadedAdsData) { [weak self] downloadedAds in
                    guard let self = self else { return }
                    self.ads = downloadedAds
                    self.adCollectionDataSource.ads = downloadedAds
                    self.adCollectionDelegateHandler.ads = downloadedAds
                    self.collectionView.reloadData()
                }
            }
        }
    }

    private func fetchAdCategoriesDict() {
        adNetworkManager.getAdCategoriesDict { [weak self] result in
            guard let self = self else { return }
            self.activityView.stopAnimating()
            switch result {
            case .failure(let networkError): self.showErrorAlert(message: networkError.message)
            case .success(let downloadedAdCategoriesDict):
                self.adCategoriesDict = downloadedAdCategoriesDict
                self.adCollectionDataSource.adCategoriesDict = downloadedAdCategoriesDict
                self.adCollectionDelegateHandler.adCategoriesDict = downloadedAdCategoriesDict
                self.collectionView.reloadData()
            }
        }
    }

    private func showActivityIndicatory() {
        activityView.center = view.center
        activityView.color = .darkGray
        activityView.style = .gray
        view.addSubview(activityView)
        activityView.startAnimating()
    }

    func showErrorAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur réseau", message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private lazy var adCollectionDelegateHandler: AdCollectionDelegateHandler = AdCollectionDelegateHandler(
        screenWidth: view.bounds.width,
        ads: ads,
        adCategoriesDict: adCategoriesDict,
        navigationController: navigationController
    )

    private lazy var adCollectionDataSource: AdCollectionDataSource = AdCollectionDataSource(
        ads: ads,
        adCategoriesDict: adCategoriesDict
    )
}

extension AdCollectionViewController: AdCategoryFilterViewDelegate {
    func pushWhenModalIsDismissed(filteredAdTableViewController: FilteredAdTableViewController) {
        navigationController?.pushViewController(filteredAdTableViewController, animated: true)
    }
}
