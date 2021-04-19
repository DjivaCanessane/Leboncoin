//  swiftlint:disable identifier_name
//  ViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import UIKit

class AdCollectionViewController: UIViewController {

    // MARK: - INTERNAL

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

    let spacing: CGFloat = 16.0
    private let adNetworkManager: AdNetworkManager = AdNetworkManager.shared
    private let activityView = UIActivityIndicatorView(style: .large)

    var ads: Ads = []
    var adCategoriesDict: AdCategoriesDict = [:]

    private lazy var filterButton: UIBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
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

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
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

    @objc
    private func presentAdCategoriesModally() {
        let adCategoryFilterViewController = AdCategoryFilterViewController()
        adCategoryFilterViewController.delegate = self
        adCategoryFilterViewController.adCategoriesDict = adCategoriesDict
        adCategoryFilterViewController.ads = ads
        adCategoryFilterViewController.modalPresentationStyle = .automatic

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
                self.collectionView.reloadData()
            }
        }
    }

    private func showActivityIndicatory() {
        activityView.center = view.center
        activityView.color = .darkGray
        activityView.style = .large
        view.addSubview(activityView)
        activityView.startAnimating()
    }

    func showErrorAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur réseau", message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
}

extension AdCollectionViewController: AdCategoryFilterViewDelegate {
    func pushWhenModalIsDismissed(filteredAdTableViewController: FilteredAdTableViewController) {
        navigationController?.pushViewController(filteredAdTableViewController, animated: true)
    }
}
