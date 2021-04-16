//
//  AdsTestCase.swift
//  LeboncoinTests
//
//  Created by Djiveradjane Canessane on 16/04/2021.
//

import XCTest
@testable import Leboncoin

class AdsTestCase: XCTestCase {

    func testGetAds_WhenGetAdsData_ShouldBeArranged_ByEmmergencyAndCreationDate() {
        let correctData: Data? = FakeResponseData.generateData(for: "AdsDataForArrangeTest")
        setUpFakes(data: correctData, response: FakeResponseData.responseOK, error: nil)

        adNetworkManagerFake.getAds { result in
            switch result {
            case .success(let ads):
                let filterdAds: Ads = ads.filter(categoryID: 4)
                filterdAds.forEach {
                    XCTAssertEqual($0.categoryID, 4)
                }
            case .failure(let error): XCTFail("With error: \(error)")
            }
        }
    }

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
