//
//  Test_WeatherListViewController.swift
//  test_exomind_weatherTests
//
//  Created by zhizi yuan on 29/07/2021.
//

import XCTest
import Moya_ObjectMapper
import Moya

@testable import test_exomind_weather
class TestWeatherListViewController: XCTestCase {

    var sut: WeatherListViewController!
    var weatherListViewModel: WeatherListViewModel!
    var provider: MoyaProvider<WeatherListService>!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "WeatherListViewController") as? WeatherListViewController
        weatherListViewModel = WeatherListViewModel()
        sut.viewModel = weatherListViewModel

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        weatherListViewModel = nil
        try super.tearDownWithError()
    }

    func test_downloadWeather_success() throws {
        //Given
        let provider = MockMoyaProvider.providerSuccess()
        sut.viewModel.moyaProvider = provider
        let expectation = XCTestExpectation()
        //When
       _ = sut.view

        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            //test UI state during download
            XCTAssertTrue(self.sut.restartButton.isHidden)
            XCTAssertFalse(self.sut.progressive.isHidden)
            XCTAssertFalse(self.sut.titleProgressiveLabel.isHidden)
            XCTAssertFalse(self.sut.percentLabel.isHidden)
            if !self.sut.restartButton.isHidden ||
                self.sut.progressive.isHidden ||
                self.sut.titleProgressiveLabel.isHidden ||
                self.sut.percentLabel.isHidden {
                expectation.fulfill()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 65) {
            //test UI state after download
            XCTAssertEqual(self.sut.tableView.numberOfRows(inSection: 0), 5)
            XCTAssertFalse(self.sut.restartButton.isHidden)
            XCTAssertTrue(self.sut.progressive.isHidden)
            XCTAssertTrue(self.sut.titleProgressiveLabel.isHidden)
            XCTAssertTrue(self.sut.percentLabel.isHidden)
            XCTAssertEqual(self.sut.indicator.text, "")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 75)
    }

    func test_downloadWeather_error() throws {
        //Given
        let provider = MockMoyaProvider.providerErrorStatusCode()
        sut.viewModel.moyaProvider = provider
        let expectation = XCTestExpectation()
        //When
       _ = sut.view

        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //test UI state when error occur
            XCTAssertFalse(self.sut.restartButton.isHidden)
            XCTAssertTrue(self.sut.progressive.isHidden)
            XCTAssertTrue(self.sut.titleProgressiveLabel.isHidden)
            XCTAssertTrue(self.sut.percentLabel.isHidden)
            XCTAssertEqual(self.sut.indicator.text, "")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)

    }

}
