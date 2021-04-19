//
//  AdsTestCase.swift
//  LeboncoinTests
//
//  Created by Djiveradjane Canessane on 16/04/2021.
//

import XCTest
@testable import Leboncoin

class AdsTestCase: XCTestCase {

    // MARK: - Ads.filter() test

    func testAdsfilter_ShouldReturnFilteredAds_ByGivenCategoryID() {
        let adsUndecodedData: Data = FakeResponseData.generateData(for: "AdsDataForArrangeTest")!
        var adsData: AdsData!
        do {
            adsData = try JSONDecoder().decode(AdsData.self, from: adsUndecodedData)
        } catch let error {
            XCTFail("Can not decode adsUndecodedData, with error: \(error)")
        }
        var ads: Ads = []
        adsData.forEach { ads.append(makeAd(from: $0)) }

        let filterdAds: Ads = ads.filter(categoryID: 4)
        XCTAssertEqual(filterdAds.count, 3)
        filterdAds.forEach { XCTAssertEqual($0.categoryID, 4) }

    }

    // MARK: - PRIVATE

    // MARK: Properties

    private var adNetworkManagerFake: AdNetworkManager!

    // MARK: Methods

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

    private func getAdDate(from adData: AdData) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: adData.creationDate) ?? .distantPast
    }

}
