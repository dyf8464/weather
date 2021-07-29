//
//  MockMoayProvider.swift
//  test_exomind_weatherTests
//
//  Created by zhizi yuan on 28/07/2021.
//

import Moya
import Alamofire
@testable import test_exomind_weather
struct MockMoyaProvider {
    static func providerSuccess() -> MoyaProvider<WeatherListService> {
       return MoyaProvider<WeatherListService>(endpointClosure: MockEndPoint.successEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }

    static func providerWithOutInternet() -> MoyaProvider<WeatherListService> {
        return MoyaProvider<WeatherListService>(endpointClosure: MockEndPoint.errorNoInternetEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }

    static func providerErrorStatusCode() -> MoyaProvider<WeatherListService> {
        return MoyaProvider<WeatherListService>(endpointClosure: MockEndPoint.erroStatusCodeEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    }
}
