//
//  test_WeatherListService.swift
//  test_exomind_weatherTests
//
//  Created by zhizi yuan on 28/07/2021.
//

import XCTest
import Moya_ObjectMapper
import Moya
import RxSwift
import Alamofire
@testable import test_exomind_weather
class TestWeatherListService: XCTestCase {

    var sut: MoyaProvider<WeatherListService>!
    var disposeBag: DisposeBag!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       try super.setUpWithError()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag = nil
        try super.tearDownWithError()
    }

    // MARK: - TEST API
    func test_rx_requst_weatherBy_success() throws {
        //Given
        let expectation = XCTestExpectation()
        sut = MockMoyaProvider.providerSuccess()

        //When
       sut.rx.request(.weatherBy(nameCity: "Paris"))
            .mapObject(WeatherModel.self)
            .subscribe {
              switch $0 {
              case .success(let weather):
                //Then
                XCTAssertEqual(weather.nameCity, "Paris")
                expectation.fulfill()
              case .error(_):
                XCTAssertTrue(false)
                expectation.fulfill()
              }
            }.disposed(by: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }

    func test_rx_requst_weatherBy_error_stauts_code() throws {
        //Given
        let expectation = XCTestExpectation()
        sut = MockMoyaProvider.providerErrorStatusCode()

        //When
       sut.rx.request(.weatherBy(nameCity: "Paris"))
        .mapObject(WeatherModel.self).subscribe {
              switch $0 {
              case .success(_):
                XCTAssertTrue(false)
                expectation.fulfill()
              case .error(let error):
                guard let moyaError = error as? Moya.MoyaError
                else {
                  return
                }
                switch moyaError {
                case .underlying(_, let response):
                    //Then
                    XCTAssertEqual(response?.statusCode, 404)
                default:
                   XCTAssertTrue(false)
                }
                expectation.fulfill()
              }
            }.disposed(by: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }

    func test_rx_requst_weatherBy_error_without_internet() throws {
        //Given
        let expectation = XCTestExpectation()
        sut = MockMoyaProvider.providerWithOutInternet()

        //When
       sut.rx.request(.weatherBy(nameCity: "Paris"))
        .mapObject(WeatherModel.self).subscribe {
              switch $0 {
              case .success(_):
                XCTAssertTrue(false)
                expectation.fulfill()
              case .error(let error):
                guard let moyaError = error as? Moya.MoyaError
                else {
                  XCTAssertTrue(false)
                  expectation.fulfill()
                  return
                }
                switch moyaError {
                //Then
                case .underlying(let afError, _):
                    if let nsError = (afError as? Alamofire.AFError)?.underlyingError as NSError? {
                        XCTAssertEqual(nsError.domain, NSURLErrorDomain)
                        XCTAssertEqual(nsError.code, NSURLErrorNotConnectedToInternet)
                    } else {
                        XCTAssertTrue(false)
                    }

                default:
                   XCTAssertTrue(false)
                }
                expectation.fulfill()
              }
            }.disposed(by: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }

}
