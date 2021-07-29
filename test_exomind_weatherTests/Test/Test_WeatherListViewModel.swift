//
//  Test_WeatherListViewModel.swift
//  test_exomind_weatherTests
//
//  Created by zhizi yuan on 28/07/2021.
//

import XCTest
import Moya_ObjectMapper
import Moya
import RxSwift
import RxCocoa
import Alamofire
@testable import test_exomind_weather
class TestWeatherListViewModel: XCTestCase {
    var sut: WeatherListViewModel!
    var provider: MoyaProvider<WeatherListService>!
    let viewBinder = UIView()
    var disposeBag: DisposeBag!

    //Mock progressViewBinder
    var progressViewBinderTest: [Float]!
    var progressViewBinder: Binder<Float>!

    //Mock indicatorBinder
    var indicatorBinderTest: [String?]!
    var indicatorBinder: Binder<String?>!

    //Mock percentBinder
    var percentBinderTest: [String?]!
    var percentBinder: Binder<String?>!

    //Mock alertMessage
    var alertMessage: AlertMessage!

    //Mock indicator text
    var indicatorText: String!

    //Mock state downloading
    var downloading: Bool!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = WeatherListViewModel()
        disposeBag = DisposeBag()

        //Mock progressViewBinder
        progressViewBinderTest = [Float]()
        progressViewBinder = Binder(viewBinder) { [weak self] in
            guard let self = self else {
                return
            }
            let string = String(format: "%.1f", $1)
            self.progressViewBinderTest.append(Float(string)!)
        }

        //Mock indicatorBinder
        indicatorBinderTest = [String?]()
        indicatorBinder = Binder(viewBinder) { [weak self] in
            guard let self = self else {
                return
            }
            self.indicatorBinderTest.append($1)
        }

        //Mock percentBinder
         percentBinderTest = [String?]()
         percentBinder = Binder(viewBinder) { [weak self] in
            guard let self = self else {
                return
            }
            self.percentBinderTest.append($1)
        }

        //Mock indicator text
        indicatorText = "indicatorTextTest"
        sut.indicatorTextBehaviorRelay.subscribe { [weak self] (text: String) in
            guard let self = self else {
                return
            }
            self.indicatorText = text
        }.disposed(by: disposeBag)

        //Mock state downloading
        downloading = false
        sut.downloadingBehaviorRelay.subscribe {
            self.downloading = $0
        }.disposed(by: disposeBag)

        sut.alertMessagePublishSubjet.subscribe { [weak self] (alertMessage: AlertMessage) in
            guard let self = self else {
                return
            }
            self.alertMessage = alertMessage
        }.disposed(by: disposeBag)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        disposeBag = nil
        progressViewBinderTest = nil
        indicatorBinderTest = nil
        percentBinderTest = nil
        indicatorText = nil
        alertMessage = nil
        try super.tearDownWithError()
    }

    func test_downloadWeathers_success() throws {
        //Given
        let provider = MockMoyaProvider.providerSuccess()
        sut.moyaProvider = provider

        let expectation = XCTestExpectation()

        //When
        sut.downloadWeathers(progressViewBinder: progressViewBinder, indicatorBinder: indicatorBinder, percentBinder: percentBinder)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //Then
            //test "downloading" is true when weather being downloaded
            XCTAssertTrue(self.downloading)
            if !self.downloading {
                expectation.fulfill()
            }

        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 62) {
            //Then
            //test progressViewBinder
            XCTAssertEqual(self.progressViewBinderTest, [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])

            //test percentBinder
            XCTAssertEqual(self.percentBinderTest, ["0%", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"])

            //test indicator
            //4 times EnumIndicator.indicator1 : "Nous téléchargeon les données..."
            let indicator1 = self.indicatorBinderTest.filter {$0 == WeatherListViewModel.EnumIndicator.indicator1.rawValue}
            XCTAssertEqual(indicator1.count, 4)

            //4 times EnumIndicator.indicator2 : "C'est presque fini..."
            let indicator2 = self.indicatorBinderTest.filter {$0 == WeatherListViewModel.EnumIndicator.indicator2.rawValue}
            XCTAssertEqual(indicator2.count, 4)

            //3 times EnumIndicator.indicator3 : "Plus que quelques secondes avant d'avoir le résultat..."
            let indicator3 = self.indicatorBinderTest.filter {$0 == WeatherListViewModel.EnumIndicator.indicator3.rawValue}
            XCTAssertEqual(indicator3.count, 3)

            //test weatherViewModelListBehaviorRelay has 5 weathers
            XCTAssertEqual(self.sut.weatherViewModelListBehaviorRelay.value.count, 5)

            //test indicator is string empty after download
            XCTAssertEqual(self.indicatorText, "")

            //test downloading is false after download
            XCTAssertFalse(self.downloading)

            //test alertMessage is nil
            XCTAssertNil(self.alertMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 65.0)
    }

    func test_downloadWeathers_error_statusCode() throws {
        //Given
        let provider = MockMoyaProvider.providerErrorStatusCode()
        sut.moyaProvider = provider

        let expectation = XCTestExpectation()

        //When
        sut.downloadWeathers(progressViewBinder: progressViewBinder, indicatorBinder: indicatorBinder, percentBinder: percentBinder)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //Then

            //test weatherViewModelListBehaviorRelay is empty
            XCTAssertEqual(self.sut.weatherViewModelListBehaviorRelay.value.count, 0)

            //test indicator is string empty if error occur
            XCTAssertEqual(self.indicatorText, "")

            //test downloading is false if error occur
            XCTAssertFalse(self.downloading)

            XCTAssertEqual(self.alertMessage, AlertMessage.serveur)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_downloadWeathers_error_without_internet() throws {
        //Given
        let provider = MockMoyaProvider.providerWithOutInternet()
        sut.moyaProvider = provider

        let expectation = XCTestExpectation()

        //When
        sut.downloadWeathers(progressViewBinder: progressViewBinder, indicatorBinder: indicatorBinder, percentBinder: percentBinder)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //Then

            //test weatherViewModelListBehaviorRelay is empty
            XCTAssertEqual(self.sut.weatherViewModelListBehaviorRelay.value.count, 0)

            //test indicator is string empty if error occur
            XCTAssertEqual(self.indicatorText, "")

            //test downloading is false if error occur
            XCTAssertFalse(self.downloading)

            XCTAssertEqual(self.alertMessage, AlertMessage.internet)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

}
