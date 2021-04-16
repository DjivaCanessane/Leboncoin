//
//  AdsTestCase.swift
//  LeboncoinTests
//
//  Created by Djiveradjane Canessane on 16/04/2021.
//

import XCTest
@testable import Leboncoin

class AdsTestCase: XCTestCase {

    // MARK: - Ads.filter() tests

    func testAdsfilter_ShouldReturnFilteredAds_ByGivenCategoryID() {
        let data: Data? = FakeResponseData.generateData(for: "AdsDataForArrangeTest")
        setUpFakes(data: data, response: FakeResponseData.responseOK, error: nil)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getAds { result in
            switch result {
            case .success(let ads):
                let filterdAds: Ads = ads.filter(categoryID: 4)
                XCTAssertEqual(filterdAds.count, 3)
                filterdAds.forEach { XCTAssertEqual($0.categoryID, 4) }
            case .failure(let error): XCTFail("With error: \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private var adNetworkManagerFake: AdNetworkManager!

    // MARK: Methods

    private func setUpFakes(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?,
        adsURLStr: String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
    ) {
        let urlSessionFake: URLSessionFake = URLSessionFake(data: data, response: response, error: error)
        let networkServiceFake: NetworkService! = NetworkService(networkSession: urlSessionFake)
        adNetworkManagerFake = AdNetworkManager(adNetworkService: networkServiceFake, adsURLStr: adsURLStr)
    }

}
