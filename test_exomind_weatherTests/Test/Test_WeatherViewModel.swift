//
//  Test_WeatherViewModel.swift
//  test_exomind_weatherTests
//
//  Created by zhizi yuan on 28/07/2021.
//

import XCTest
@testable import test_exomind_weather
class TestWeatherViewModel: XCTestCase {

    let url = URL(fileURLWithPath: Bundle.main.path(forResource: "Paris", ofType: "json")!)
    var sut: WeatherViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut =  WeatherModel(JSONString: String(decoding: try Data(contentsOf: url), as: UTF8.self))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testProperties() throws {
        XCTAssertEqual(sut.nameCityVM, "Paris")
        XCTAssertEqual(sut.temperatureVM, "292.71 °C")
        XCTAssertEqual(sut.cloudsVM, "75 %")
    }

    func testPropertiesEmpty() throws {
        var model = sut as? WeatherModel
        model?.clouds = nil
        model?.nameCity = nil
        model?.temperature = nil
        sut = model

        XCTAssertEqual(sut.nameCityVM, "")
        XCTAssertEqual(sut.temperatureVM, "")
        XCTAssertEqual(sut.cloudsVM, "")
    }

}
