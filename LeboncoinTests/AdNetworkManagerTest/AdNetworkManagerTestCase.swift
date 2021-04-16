//  swiftlint:disable identifier_name
//  AdNetworkManagerTestCase.swift
//  LeboncoinTests
//
//  Created by Djiveradjane Canessane on 14/04/2021.
//

import XCTest
@testable import Leboncoin

class AdNetworkManagerTestCase: XCTestCase {

    // MARK: - getAdsData() tests

    func testGetAdsData_WhenSessionGotError_ShouldPostFailedCallback_WithNetworkError() {
        setUpFakes(data: nil, response: nil, error: FakeResponseData.error)
        shouldGet(expectedError: .hasError)
    }

    func testGetAdsData_WhenDataIsWrongFormat_ShouldNotDecodeJsonAndRetrunFailedCallback_WithError() {
        let wrongFormatData: Data? = FakeResponseData.generateData(for: "UndecodableAdsData")
        setUpFakes(data: wrongFormatData, response: FakeResponseData.responseOK, error: nil)
        shouldGet(expectedError: .canNotDecode)
    }

    func testGetAdsData_WhenCanNotMakeURLFromURLStr_ShouldReturnFailedCallback_WithInvalidURLError() {
        setUpFakes(data: nil, response: nil, error: nil, adsURLStr: "")
        shouldGet(expectedError: .invalidURL)
    }

    func testGetAdsData_WhenSessionHasDataAndResponseOK_ShouldPostSuccessCallback_WithAdsData() {
        let correctData: Data? = FakeResponseData.generateData(for: "CompleteAdData")
        setUpFakes(data: correctData, response: FakeResponseData.responseOK, error: nil)

        adNetworkManagerFake.getAdsData { result in
            switch result {
            case .success(let adsData): self.isAdDataPropertiesConformToExpectation(adsData)
            case .failure(let error): XCTFail("With error: \(error)")
            }
        }
    }

    // MARK: - getSmallImage() tests

    func testGetSmallImage_WhenAdDataHasNotSmallImageURL_ShouldReturnAd_WithoutSmallImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        let adDataWithoutSmallImageURL: AdData = makeAdData(with: nil)

        adNetworkManagerFake.getSmallImage(for: [adDataWithoutSmallImageURL]) { ads in
            self.isAdPropertiesConformToExpectation(ad: ads[0])
        }
    }

    func testGetSmallImage_WhenAdDataHasBrokenSmallImageURL_ShouldReturnAd_WithoutSmallImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        let adDataWithInvalidImageURL: AdData = makeAdData(with: smallImageURLStr)

        adNetworkManagerFake.getSmallImage(for: [adDataWithInvalidImageURL]) { [self] ads in
            isAdPropertiesConformToExpectation(ad: ads[0], smallImageURLToTest: smallImageURLStr)
        }
    }

    func testGetSmallImage_WhenSmallImageURLIsEmpty_ShouldReturnAd_WithoutSmallImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        let adDataWithInvalidImageURL: AdData = makeAdData(with: "")

        adNetworkManagerFake.getSmallImage(for: [adDataWithInvalidImageURL]) { [self] ads in
            isAdPropertiesConformToExpectation(ad: ads[0], smallImageURLToTest: "")
        }
    }

    func testGetSmallImage_WhenAdDataHasValidSmallImageURL_ShouldReturnAd_WithSmallImageData() {
        setUpFakes(data: FakeResponseData.imageData, response: FakeResponseData.responseOK, error: nil)
        let adDataWithValidImageURL: AdData = makeAdData(with: smallImageURLStr)

        adNetworkManagerFake.getSmallImage(for: [adDataWithValidImageURL]) { [self] ads in
            isAdPropertiesConformToExpectation(
                ad: ads[0],
                smallImageURLToTest: smallImageURLStr,
                smallImageDataToTest: FakeResponseData.imageData
            )
        }
    }

    // MARK: - getThumbImage() tests

    func testGetThumbImage_WhenThumbImageURLStrIsNil_ShouldReturnAdWithoutThumbImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        let adWithoutThumbImageURL: Ad = makeAd(with: nil)

        adNetworkManagerFake.getThumbImage(for: adWithoutThumbImageURL) { ad in
            self.isAdPropertiesConformToExpectation(ad: ad)
        }
    }

    func testGetThumbImage_WhenThumbImageURLStrIsEmpty_ShouldReturnAdWithoutThumbImageData() {
        setUpFakes(data: nil, response: nil, error: nil)
        let adWithoutThumbImageURL: Ad = makeAd(with: "")

        adNetworkManagerFake.getThumbImage(for: adWithoutThumbImageURL) { ad in
            self.isAdPropertiesConformToExpectation(ad: ad, thumbImageURLToTest: "")
        }
    }

    func testGetThumbImage_WhenThumbImageURLIsInvalid_ShouldReturnAdWithoutThumbImageData() {
        setUpFakes(data: nil, response: FakeResponseData.responseKO, error: nil)
        let adWithoutThumbImageURL: Ad = makeAd(with: thumbImageURLStr)

        adNetworkManagerFake.getThumbImage(for: adWithoutThumbImageURL) { ad in
            self.isAdPropertiesConformToExpectation(ad: ad, thumbImageURLToTest: self.thumbImageURLStr)
        }
    }

    func testGetThumbImage_WhenAdHasValidThumbImageURL_ShouldReturnAdWithThumbImageData() {
        setUpFakes(data: FakeResponseData.imageData, response: FakeResponseData.responseOK, error: nil)
        let adWithoutThumbImageURL: Ad = makeAd(with: thumbImageURLStr)

        adNetworkManagerFake.getThumbImage(for: adWithoutThumbImageURL) { ad in
            self.isAdPropertiesConformToExpectation(
                ad: ad, thumbImageURLToTest: self.thumbImageURLStr,
                thumbImageDataToTest: FakeResponseData.imageData
            )
        }
    }

    // MARK: - PRIVATE

    // MARK: Properties

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
        adsURLStr: String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"
    ) {
        let urlSessionFake: URLSessionFake = URLSessionFake(data: data, response: response, error: error)
        let networkServiceFake: NetworkService! = NetworkService(networkSession: urlSessionFake)
        adNetworkManagerFake = AdNetworkManager(adNetworkService: networkServiceFake, adsURLStr: adsURLStr)
    }

    private func shouldGet(expectedError: NetworkError) {
        adNetworkManagerFake.getAdsData { result in
            switch result {
            case .success(let data): XCTFail("No error, get: \(data)")
            case .failure(let error): XCTAssertEqual(error, expectedError)
            }
        }
    }

    private func isAdDataPropertiesConformToExpectation(_ adsData: (AdsData)) {
        XCTAssertNotNil(adsData[0])
        XCTAssertEqual(adsData[0].categoryID, 9)
        XCTAssertEqual(adsData[0].id, 1664493117)
        XCTAssertEqual(adsData[0].price, 25.00)
        XCTAssertEqual(adsData[0].creationDate, "2019-11-05T15:56:55+0000")
        XCTAssertEqual(adsData[0].description, self.descriptionStr)
        XCTAssertEqual(adsData[0].title, "Professeur natif d'espagnol à domicile")
        XCTAssertEqual(adsData[0].isUrgent, false)
        XCTAssertEqual(adsData[0].imagesURL.small, self.smallImageURLStr)
        XCTAssertEqual(adsData[0].imagesURL.thumb, self.thumbImageURLStr)
        XCTAssertEqual(adsData[0].siret, "123 323 002")
    }

    private func makeAdData(with smallImageURLStr: String?) -> AdData {
        return AdData(
            id: 1664493117,
            categoryID: 9,
            title: "Professeur natif d'espagnol à domicile",
            description: descriptionStr,
            price: 25.00,
            imagesURL: ImagesURL(small: smallImageURLStr, thumb: nil),
            creationDate: "2019-11-05T15:56:55+0000",
            isUrgent: false,
            siret: "123 323 002"
        )
    }

    private func isAdPropertiesConformToExpectation(
        ad: Ad,
        smallImageURLToTest smallImageURL: String? = nil,
        smallImageDataToTest smallImageData: Data? = nil,
        thumbImageURLToTest thumbImageURL: String? = nil,
        thumbImageDataToTest thumbImageData: Data? = nil
    ) {
        XCTAssertNotNil(ad)
        XCTAssertEqual(ad.categoryID, 9)
        XCTAssertEqual(ad.id, 1664493117)
        XCTAssertEqual(ad.price, 25.00)
        XCTAssertEqual(ad.creationDate, "2019-11-05T15:56:55+0000")
        XCTAssertEqual(ad.description, self.descriptionStr)
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
            creationDate: "2019-11-05T15:56:55+0000",
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
