//
//  Test_WeatherTableViewCell.swift
//  test_exomind_weatherTests
//
//  Created by zhizi yuan on 28/07/2021.
//

import XCTest
@testable import test_exomind_weather
class TestWeatherTableViewCell: XCTestCase {

    let url = URL(fileURLWithPath: Bundle.main.path(forResource: "Paris", ofType: "json")!)
    var sut: WeatherTableViewCell!
    var weatherViewModel: WeatherViewModel!
    let modelUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "Paris", ofType: "json")!)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let tableView = UITableView()
        tableView.register(WeatherTableViewCell.nib, forCellReuseIdentifier: WeatherTableViewCell.id)
        sut = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.id)
            as? WeatherTableViewCell
        weatherViewModel =  WeatherModel(JSONString: String(decoding: try Data(contentsOf: url), as: UTF8.self))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        weatherViewModel = nil
    }

    func test_loadViewModel_success() throws {
        //Given
        let viewModel = self.weatherViewModel
        //When
        sut.loadViewModel(viewModel: viewModel!)
        //then
        sut.cityLabel.text = "Pairs"
        sut.cloudLabel.text = "75 %"
        sut.temperatureLabel.text = "292.71 °C"
    }

}
