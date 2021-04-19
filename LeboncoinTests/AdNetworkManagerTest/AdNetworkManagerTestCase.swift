//  swiftlint:disable identifier_name
//  AdNetworkManagerTestCase.swift
//  LeboncoinTests
//
//  Created by Djiveradjane Canessane on 14/04/2021.
//

// Timeout delay are set to 0.02 seconds instead 0.01
// to avoid tests to fail when the Mac performances are slow due to other apps

import XCTest
@testable import Leboncoin

// MARK: - getAds() tests

extension AdNetworkManagerTestCase {

    // MARK: Tests NetworkService errors

    func testGetAdsData_WhenSessionGotError_ShouldPostFailedCallback_WithNetworkError() {
        setUpFakes(data: nil, response: nil, error: FakeResponseData.error)
        shouldGet(error: .hasError, for: adNetworkManagerFake.getAdsData)
    }

    func testGetAdsData_WhenCanNotMakeURLFromURLStr_ShouldReturnFailedCallback_WithInvalidURLError() {
        setUpFakes(data: nil, response: nil, error: nil, adsURLStr: "")
        shouldGet(error: .invalidURL, for: adNetworkManagerFake.getAdsData)
    }

    func testGetAdsData_WhenDataIsWrongFormat_ShouldNotDecodeJsonAndRetrunFailedCallback_WithError() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "UndecodableAdsData")
        setUpFakes(data: wrongFormatData, response: FakeResponseData.responseOK, error: nil)
        shouldGet(error: .canNotDecode, for: adNetworkManagerFake.getAdsData)
    }

    // MARK: Test GetAds success

    func testGetAds_WhenGetAdsData_ShouldBeArranged_ByEmmergencyAndCreationDate() {
        let correctData: Data? = FakeResponseData.generateData(for: "AdsDataForArrangeTest")
        setUpFakes(data: correctData, response: FakeResponseData.responseOK, error: nil)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getAdsData { result in
            switch result {
            case .success(let adsData):
                XCTAssertFalse(adsData[0].isUrgent)
                XCTAssertEqual(adsData[0].creationDate, "2019-10-11T12:18:39+0000")

                XCTAssertTrue(adsData[1].isUrgent)
                XCTAssertEqual(adsData[1].creationDate, "2019-12-06T11:22:02+0000")

                XCTAssertFalse(adsData[2].isUrgent)
                XCTAssertEqual(adsData[2].creationDate, "2019-01-06T11:21:53+0000")

                XCTAssertTrue(adsData[3].isUrgent)
                XCTAssertEqual(adsData[3].creationDate, "2019-04-06T11:21:48+0000")

                XCTAssertFalse(adsData[4].isUrgent)
                XCTAssertEqual(adsData[4].creationDate, "2019-11-06T11:21:46+0000")
            case .failure(let error): XCTFail("With error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }
}

// MARK: - getSmallImage() tests

extension AdNetworkManagerTestCase {

    // MARK: Tests URL related errors

    func testGetSmallImage_WhenAdDataHasNotSmallImageURL_ShouldReturnAd_WithoutSmallImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        let adDataWithoutSmallImageURL: AdData = makeAdData(with: nil)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getSmallImage(for: [adDataWithoutSmallImageURL]) { ads in
            self.isAdPropertiesConformToExpectation(ad: ads[0])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }

    func testGetSmallImage_WhenAdDataHasBrokenSmallImageURL_ShouldReturnAd_WithoutSmallImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        let adDataWithInvalidImageURL: AdData = makeAdData(with: smallImageURLStr)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getSmallImage(for: [adDataWithInvalidImageURL]) { [self] ads in
            isAdPropertiesConformToExpectation(ad: ads[0], expectedSmallImageURL: smallImageURLStr)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }

    func testGetSmallImage_WhenSmallImageURLIsEmpty_ShouldReturnAd_WithoutSmallImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        let adDataWithEmptyImageURL: AdData = makeAdData(with: "")
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getSmallImage(for: [adDataWithEmptyImageURL]) { [self] ads in
            isAdPropertiesConformToExpectation(ad: ads[0], expectedSmallImageURL: "")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }

    // MARK: test Success

    func testGetSmallImage_WhenAdDataHasValidSmallImageURL_ShouldReturnAd_WithSmallImageData() {
        setUpFakes(data: FakeResponseData.dummyData, response: FakeResponseData.responseOK, error: nil)
        let adDataWithValidImageURL: AdData = makeAdData(with: smallImageURLStr)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getSmallImage(for: [adDataWithValidImageURL]) { [self] ads in
            isAdPropertiesConformToExpectation(
                ad: ads[0],
                expectedSmallImageURL: smallImageURLStr,
                expectedSmallImageData: FakeResponseData.dummyData
            )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }

    // MARK: Test DateFormatter error

    func testGetSmallImage_WhenSessionHasData_ButAdDataDateIsWrongFormat_ShouldPostAdCallback_DatedAtDistantPast() {
        setUpFakes(data: FakeResponseData.dummyData, response: FakeResponseData.responseOK, error: nil)
        let adDataWithIncorrectDate: AdData = makeAdData(with: smallImageURLStr, date: "")
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getSmallImage(for: [adDataWithIncorrectDate]) { ads in
            XCTAssertEqual(ads[0].creationDate, Date.distantPast)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    // MARK: Test if ads are arranged

    func testGetSmallImage_WhenPostAdsInCallback_ShouldBeArranged_ByEmmergencyAndCreationDate() {
        setUpFakes(data: FakeResponseData.dummyData, response: FakeResponseData.responseOK, error: nil)
        let adsUndecodedData: Data = FakeResponseData.generateData(for: "AdsDataForArrangeTest")!
        var adsData: AdsData!
        do {
            adsData = try JSONDecoder().decode(AdsData.self, from: adsUndecodedData)
        } catch let error {
            XCTFail("Can not decode adsUndecodedData, with error: \(error)")
        }

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getSmallImage(for: adsData) { [self] ads in
            XCTAssertTrue(ads[0].isUrgent)
            XCTAssertEqual(ads[0].creationDate, dateFormatter.date(from: "2019-12-06T11:22:02+0000")!)

            XCTAssertTrue(ads[1].isUrgent)
            XCTAssertEqual(ads[1].creationDate, dateFormatter.date(from: "2019-04-06T11:21:48+0000")!)

            XCTAssertFalse(ads[2].isUrgent)
            XCTAssertEqual(ads[2].creationDate, dateFormatter.date(from: "2019-11-06T11:21:46+0000")!)

            XCTAssertFalse(ads[3].isUrgent)
            XCTAssertEqual(ads[3].creationDate, dateFormatter.date(from: "2019-10-11T12:18:39+0000")!)

            XCTAssertFalse(ads[4].isUrgent)
            XCTAssertEqual(ads[4].creationDate, dateFormatter.date(from: "2019-01-06T11:21:53+0000")!)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }
}

// MARK: - getAdCategoriesDict() tests

extension AdNetworkManagerTestCase {
    func testGetAdCategoriesDict_WhenSessionGotError_ShouldPostFailedCallback_WithNetworkError() {
        setUpFakes(data: nil, response: nil, error: FakeResponseData.error)
        shouldGet(error: .hasError, for: adNetworkManagerFake.getAdCategoriesDict)
    }

    func testGetAdCategoriesDict_WhenCanNotMakeURLFromURLStr_ShouldReturnFailedCallback_WithInvalidURLError() {
        setUpFakes(data: nil, response: nil, error: nil, adCategoriesURLStr: "")
        shouldGet(error: .invalidURL, for: adNetworkManagerFake.getAdCategoriesDict)
    }

    func testGetAdCategoriesDict_WhenDataIsWrongFormat_ShouldNotDecodeJsonAndRetrunFailedCallback_WithError() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "UndecodableAdsData")
        setUpFakes(data: wrongFormatData, response: FakeResponseData.responseOK, error: nil)
        shouldGet(error: .canNotDecode, for: adNetworkManagerFake.getAdCategoriesDict)
    }

    func testGetAdCategoriesDict_WhenSessionHasDataAndResponseOK_ShouldPostSuccessCallback_WithAdCategories() {
        let correctData: Data? = FakeResponseData.generateData(for: "AdCategories")
        setUpFakes(data: correctData, response: FakeResponseData.responseOK, error: nil)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getAdCategoriesDict { result in
            switch result {
            case .success(let adCategoriesDict):
                XCTAssertEqual(adCategoriesDict[1], "Véhicule")
                XCTAssertEqual(adCategoriesDict[2], "Mode")
            case .failure(let error): XCTFail("With error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }
}

// MARK: - getThumbImage() tests

extension AdNetworkManagerTestCase {
    func testGetThumbImage_WhenThumbImageURLStrIsNil_ShouldReturnAdWithoutThumbImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        var adWithoutThumbImageURL: Ad = makeAd(with: nil)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getThumbImage(for: adWithoutThumbImageURL) { thumbImageData in
            adWithoutThumbImageURL.thumbImageData = thumbImageData
            self.isAdPropertiesConformToExpectation(ad: adWithoutThumbImageURL)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }

    func testGetThumbImage_WhenThumbImageURLStrIsEmpty_ShouldReturnAdWithoutThumbImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        var adWithoutThumbImageURL: Ad = makeAd(with: "")
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getThumbImage(for: adWithoutThumbImageURL) { thumbImageData in
            adWithoutThumbImageURL.thumbImageData = thumbImageData
            self.isAdPropertiesConformToExpectation(ad: adWithoutThumbImageURL, expectedThumbImageURL: "")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }

    func testGetThumbImage_WhenThumbImageURLIsInvalid_ShouldReturnAdWithoutThumbImageData() {
        setUpFakes(data: nil, response: FakeResponseData.responseKO, error: nil)
        var adWithoutThumbImageURL: Ad = makeAd(with: thumbImageURLStr)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getThumbImage(for: adWithoutThumbImageURL) { [self] thumbImageData in
            adWithoutThumbImageURL.thumbImageData = thumbImageData
            isAdPropertiesConformToExpectation(
                ad: adWithoutThumbImageURL,
                expectedThumbImageURL: thumbImageURLStr
            )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }

    func testGetThumbImage_WhenAdHasValidThumbImageURL_ShouldReturnAdWithThumbImageData() {
        setUpFakes(data: FakeResponseData.dummyData, response: FakeResponseData.responseOK, error: nil)
        var adWithoutThumbImageURL: Ad = makeAd(with: thumbImageURLStr)
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        adNetworkManagerFake.getThumbImage(for: adWithoutThumbImageURL) { [self] thumbImageData in
            adWithoutThumbImageURL.thumbImageData = thumbImageData
            isAdPropertiesConformToExpectation(
                ad: adWithoutThumbImageURL,
                expectedThumbImageURL: thumbImageURLStr,
                expectedThumbImageData: FakeResponseData.dummyData
            )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }
}

// MARK: - PRIVATE

class AdNetworkManagerTestCase: XCTestCase {

    // MARK: Properties

    private let testDate: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: "2019-11-05T15:56:55+0000")!
    }()

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()

    // swiftlint:disable line_length
    private let smallImageURLStr: String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/af9c43ff5a3b3692f9f1aa3c17d7b46d8b740311.jpg"

    private let thumbImageURLStr: String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/af9c43ff5a3b3692f9f1aa3c17d7b46d8b740311.jpg"

    private let descriptionStr: String = "Doctorant espagnol, ayant fait des études de linguistique comparée français - espagnol et de traduction (thème/version) 0 la Sorbonne, je vous propose des cours d'espagnol à domicile à Paris intramuros. Actuellement j'enseigne l'espagnol dans un lycée et j'ai plus de cinq ans d'expérience comme professeur particulier, à Paris et à Madrid. Tous les niveaux, tous les âges. Je m'adapte à vos besoins et vous propose une méthode personnalisée et dynamique, selon vos point forts et vos points faibles, pour mieux travailler votre :  - Expression orale - Compréhension orale - Grammaire - Vocabulaire - Production écrite - Compréhension écrite Tarif : 25 euros/heure"
    // swiftlint:enable line_length

    private var adNetworkManagerFake: AdNetworkManager!

    // MARK: Methods

    private func setUpFakes(
        data: Data?,
        response: HTTPURLResponse?,
        error: Error?,
        adsURLStr: String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json",
        adCategoriesURLStr: String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
    ) {
        let urlSessionFake: URLSessionFake = URLSessionFake(data: data, response: response, error: error)
        let networkServiceFake: NetworkService! = NetworkService(networkSession: urlSessionFake)
        adNetworkManagerFake = AdNetworkManager(
            adNetworkService: networkServiceFake,
            adsURLStr: adsURLStr,
            adCategoriesURLStr: adCategoriesURLStr
        )
    }

    private func shouldGet<T: Codable>(
        error expectedError: NetworkError,
        for methodToTest: (@escaping (Result<T, NetworkError>) -> Void) -> Void
    ) {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        methodToTest { result in
            switch result {
            case .success(let data): XCTFail("No error, get: \(data)")
            case .failure(let error): XCTAssertEqual(error, expectedError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.02)
    }

    private func makeAdData(with smallImageURLStr: String?, date: String = "2019-11-05T15:56:55+0000") -> AdData {
        return AdData(
            id: 1664493117,
            categoryID: 9,
            title: "Professeur natif d'espagnol à domicile",
            description: descriptionStr,
            price: 25.00,
            imagesURL: ImagesURL(small: smallImageURLStr, thumb: nil),
            creationDate: date,
            isUrgent: false,
            siret: "123 323 002"
        )
    }

    private func isAdPropertiesConformToExpectation(
        ad: Ad,
        expectedSmallImageURL smallImageURL: String? = nil,
        expectedSmallImageData smallImageData: Data? = nil,
        expectedThumbImageURL thumbImageURL: String? = nil,
        expectedThumbImageData thumbImageData: Data? = nil
    ) {
        XCTAssertEqual(ad.categoryID, 9)
        XCTAssertEqual(ad.id, 1664493117)
        XCTAssertEqual(ad.price, 25.00)
        XCTAssertEqual(ad.creationDate, testDate)
        XCTAssertEqual(ad.description, descriptionStr)
        XCTAssertEqual(ad.title, "Professeur natif d'espagnol à domicile")
        XCTAssertEqual(ad.isUrgent, false)
        XCTAssertEqual(ad.smallImageURLString, smallImageURL)
        XCTAssertEqual(ad.smallImageData, smallImageData)
        XCTAssertEqual(ad.thumbImageURLString, thumbImageURL)
        XCTAssertEqual(ad.thumbImageData, thumbImageData)
        XCTAssertEqual(ad.siret, "123 323 002")
    }

    private func makeAd(with thumbImageURLStr: String?) -> Ad {
        return Ad(
            id: 1664493117,
            creationDate: testDate,
            title: "Professeur natif d'espagnol à domicile",
            description: descriptionStr,
            categoryID: 9,
            price: 25.00,
            isUrgent: false,
            siret: "123 323 002",
            smallImageURLString: nil,
            smallImageData: nil,
            thumbImageURLString: thumbImageURLStr,
            thumbImageData: nil
        )
    }

}
