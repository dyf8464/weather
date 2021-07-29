//
//  WeatherListViewModel.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//
import Foundation
import RxSwift
import RxCocoa
import Moya_ObjectMapper
import Moya
import Alamofire
import Foundation

class WeatherListViewModel {

    ///Enum for message of indicator
    enum EnumIndicator: String, CaseIterable {
        case indicator1 = "Nous téléchargeon les données..."
        case indicator2 = "C'est presque fini..."
        case indicator3 = "Plus que quelques secondes avant d'avoir le résultat..."
    }

    ///Enum for weather of cities
    enum EnumWeatherCity: String, CaseIterable {
        case city1 = "Paris"
        case city2 = "Rouen"
        case city3 = "New York"
        case city4 = "Bordeaux"
        case city5 = "London"
    }

    private var disposeBag: DisposeBag?

    /// array of WeatherViewModel downloaded
    private var weatherViewModelList = [WeatherViewModel]()

    /// BehaviorRelay of array WeatherViewModel for update UI
    let weatherViewModelListBehaviorRelay = BehaviorRelay<[WeatherViewModel]>(value: [])

    /// BehaviorRelay for update indicator
    let indicatorTextBehaviorRelay = BehaviorRelay<String>(value: "")

    /// provider download
    var moyaProvider =  MoyaProvider<WeatherListService>()

    /// PublishSubject for send alert message
    var alertMessagePublishSubjet = PublishSubject<AlertMessage>()

    /// BehaviorRelay for state downloading
    var downloadingBehaviorRelay = BehaviorRelay<Bool>(value: false)

    /// download all weathers
    /// - Parameters:
    ///   - progressViewBinder: binder for update progress View
    ///   - indicatorBinder: binder for update indicator View
    ///   - percentBinder: binder for update percentage View
    func downloadWeathers(progressViewBinder: Binder<Float>, indicatorBinder: Binder<String?>,
                          percentBinder: Binder<String?>) {
        self.clearElements()
        self.disposeBag = DisposeBag()
        downloadingBehaviorRelay.accept(true)

        // launch weather api
        self.requestWeathers()

        //launch progressview and indicator
        let timer = self.startProgressviewAndIndicator(progressViewBinder: progressViewBinder, indicatorBinder: indicatorBinder, percentBinder: percentBinder)

        //handle action after timer is finished
        timer?.observeOn(MainScheduler.instance).subscribe(onCompleted: {
            self.progressviewCompletion()
        }).disposed(by: disposeBag!)
    }

    /// animate progress and indicator
    /// - Parameters:
    ///   - progressViewBinder: binder for update progress View
    ///   - indicatorBinder: binder for update indicator View
    ///   - percentBinder: binder for update percentage View
    /// - Returns: timer for animate progress and indicator
    private func startProgressviewAndIndicator(progressViewBinder: Binder<Float>, indicatorBinder: Binder<String?>, percentBinder: Binder<String?>) -> Observable<Int>? {
        guard let disposeBag = self.disposeBag else {
            return nil
        }
        let timer = Observable<Int>.timer(RxTimeInterval.seconds(-6), period: RxTimeInterval.seconds(6), scheduler: MainScheduler.instance).take(11)

        //for progressview
        timer.map { Float($0) * 0.1}.bind(to: progressViewBinder).disposed(by: disposeBag)

        //for percent label
        timer.map { String($0 * 10) + "%"}.bind(to: percentBinder).disposed(by: disposeBag)

        //for indicator label
        let indicators = EnumIndicator.allCases
        timer.map {
            let index = $0%indicators.count
            return indicators[index].rawValue}.bind(to: indicatorBinder).disposed(by: disposeBag)
        return timer
    }

    /// action after progressview value is 100%
    private func progressviewCompletion() {
        weatherViewModelListBehaviorRelay.accept(self.weatherViewModelList)
        self.indicatorTextBehaviorRelay.accept("")
        self.downloadingBehaviorRelay.accept(false)
    }

    ///launch api weather request in serial, interval is 10 seconds
    private func requestWeathers() {
        guard let disposeBag = self.disposeBag else {
            return
        }
        let weatherCities = EnumWeatherCity.allCases
        Observable<Int>.timer(RxTimeInterval.seconds(-10), period: RxTimeInterval.seconds(10), scheduler: ConcurrentDispatchQueueScheduler(qos: .default)).take(weatherCities.count).flatMap {
            // api resquest
            self.moyaProvider.rx.request(.weatherBy(nameCity: weatherCities[$0].rawValue) ).mapObject(WeatherModel.self)}.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.weatherViewModelList.append($0)
        }, onError: { [weak self] in
            guard let self = self else {
                return
            }
            self.clearElements()
            self.handleError(error: $0)
        }).disposed(by: disposeBag)
    }

    /// handle error api
    private func handleError(error: Error) {
        guard let moyaError = error as? Moya.MoyaError
        else {
            // unkown error
            self.alertMessagePublishSubjet.onNext(AlertMessage.unKown)
            return
        }
        var alertMessage: AlertMessage? = nil
        switch moyaError {
        case let .underlying(afError, _):
            //connection internet error
            if let nsError = (afError as? Alamofire.AFError)?.underlyingError as NSError?, nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorNotConnectedToInternet || nsError.code == NSURLErrorTimedOut || nsError.code == NSURLErrorNetworkConnectionLost {
                alertMessage = AlertMessage.internet
            //server alertMessage
            } else {
                alertMessage = AlertMessage.serveur
            }
            //other error
        default:
            alertMessage = moyaError.errorDescription != nil ? AlertMessage(title: "Erreur", message: moyaError.errorDescription!) : AlertMessage.unKown
        }
        self.alertMessagePublishSubjet.onNext(alertMessage!)
    }

    /// clear all elements UI
    private func clearElements() {
        self.disposeBag = nil
        self.weatherViewModelList.removeAll()
        self.weatherViewModelListBehaviorRelay.accept([])
        self.downloadingBehaviorRelay.accept(false)
        self.indicatorTextBehaviorRelay.accept("")
    }

}
