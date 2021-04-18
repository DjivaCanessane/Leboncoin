//  swiftlint:disable identifier_name
//  AdNetworkManager.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation

class AdNetworkManager {
    static let shared: AdNetworkManager = AdNetworkManager()

    // MARK: - INTERNAL

    // MARK: Methods

    /// Init for dependency injection in order to test this class
    init(
        adNetworkService: NetworkService = NetworkService(),
        adsURLStr: String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json",
        adCategoriesURLStr: String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
    ) {
        self.adNetworkService = adNetworkService
        self.adsURLStr = adsURLStr
        self.adCategoriesURLStr = adCategoriesURLStr
    }

    /// Returns ads via callback, by fetching adsData from network and parsing them
    func getAds(callback: @escaping (Result<Ads, NetworkError>) -> Void) {
        getAdsData { result in
            switch result {
            case .failure(let networkError): callback(.failure(networkError))
            case .success(let adsData): self.getSmallImage(for: adsData) { callback(.success($0.arrangeAds())) }
            }
        }
    }

    /// Returns ad via callback, with either its associated smallImage or nil
    func getSmallImage(for adsData: AdsData, callback: @escaping (Ads) -> Void) {

        // DispatchGroup allows to fetch data asynchronously, and so accelerate the fetching process from the web
        let fetchGroup = DispatchGroup()
        var ads: Ads = []

        adsData.forEach { adData in
            var ad: Ad = makeAd(from: adData)

            // Check if adData has smallImageURLStr to fetch an image, else we return ad without smallImage
            guard let smallImageURLStr = adData.imagesURL.small else { return ads.append(ad) }
            guard let smallImageURL: URL = URL(string: smallImageURLStr) else { return ads.append(ad) }

            // Enter into fetchGroup to make the network call asynchronously
            fetchGroup.enter()

            adNetworkService.getNetworkResponse(with: smallImageURL) { result in
                switch result {
                case .success(let smallImageData):
                    ad.smallImageData = smallImageData
                    ads.append(ad)
                case .failure:
                    ads.append(ad)
                }

                // When we got a network response we leave the fetchGroup
                fetchGroup.leave()
            }
        }

        // Once all fetchings are accomplished, we send the array of Ad via the callback
        fetchGroup.notify(queue: .main) {
            callback(ads)
        }
    }

    /// Returns via callback categories string according to Ad.categoryIDs
    func getAdCategoriesDict(callback: @escaping (Result<AdCategoriesDict, NetworkError>) -> Void) {
        guard let adCategoriesURL = URL(string: adCategoriesURLStr) else {
            return callback(.failure(.invalidURL))
        }

        // Try to get data from the categoriesURL
        adNetworkService.getNetworkResponse(with: adCategoriesURL) { result in
            switch result {

            // In case of failure, we pass the error to AdCollectionViewController callback
            case .failure(let error): callback(.failure(error))

            // In case of success, we decode the data, then we pass the rate to AdCollectionViewController callback
            case .success(let data):
                guard let adCategories = try? JSONDecoder().decode(AdCategories.self, from: data) else {
                    return callback(.failure(.canNotDecode))
                }

                callback(.success(adCategories.getAdCategoriesDictionary()))
            }
        }
    }

    /// Returns ad via callback, with either its associated thumbImage or nil
    func getThumbImage(for ad: Ad, callback: @escaping (Data?) -> Void) {
        // Check if adData has thumbImageURLStr to fetch an image, else we return ad without smallImage
        guard let thumbImageURLStr = ad.thumbImageURLString else { return callback(nil) }
        guard let thumbImageURL: URL = URL(string: thumbImageURLStr) else { return callback(nil) }

        adNetworkService.getNetworkResponse(with: thumbImageURL) { result in
            switch result {
            case .success(let thumbImageData):
                callback(thumbImageData)
            case .failure:
                callback(nil)
            }
        }
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private var adNetworkService: NetworkService = NetworkService()
    private var adsURLStr: String
    private var adCategoriesURLStr: String

    // MARK: Methods

    /// Returns via callback fetched adsData from the URL
    private func getAdsData(callback: @escaping (Result<AdsData, NetworkError>) -> Void) {
        guard let adsURL = URL(string: adsURLStr) else {
            return callback(.failure(.invalidURL))
        }

        // Try to get data from the adsDataURL
        adNetworkService.getNetworkResponse(with: adsURL) { result in
            switch result {

            // In case of failure, we pass the error to AdCollectionViewController callback
            case .failure(let error): callback(.failure(error))

            // In case of success, we decode the data, then we pass the rate to AdCollectionViewController callback
            case .success(let data):
                guard let adsData = try? JSONDecoder().decode(AdsData.self, from: data) else {
                    return callback(.failure(.canNotDecode))
                }

                callback(.success(adsData))
            }
        }
    }

    private func getAdDate(from adData: AdData) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: adData.creationDate) ?? .distantPast
    }

    private func makeAd(from adData: AdData) -> Ad {
        return Ad(
            id: adData.id,
            creationDate: getAdDate(from: adData),
            title: adData.title,
            description: adData.description,
            categoryID: adData.categoryID,
            price: adData.price,
            isUrgent: adData.isUrgent,
            siret: adData.siret,
            smallImageURLString: adData.imagesURL.small,
            smallImageData: nil,
            thumbImageURLString: adData.imagesURL.thumb,
            thumbImageData: nil
        )
    }
}
