//
//  MockEndPoint.swift
//  test_exomind_weatherTests
//
//  Created by zhizi yuan on 28/07/2021.
//

import Moya
import Alamofire

@testable import test_exomind_weather
struct MockEndPoint {
    /// Create Endpoint for test API return success
    /// - Parameter target:WeatherListService
    /// - Returns: Mock Endpoint success
    static func successEndpointClosure(_ target: WeatherListService) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData)  },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    /// Create Endpoint for test API return error code status 404
    /// - Parameter target:WeatherListService
    /// - Returns: Mock Endpoint error
    static func erroStatusCodeEndpointClosure(_ target: WeatherListService) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(404, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    /// Create Endpoint for test API without internet
    /// - Parameter target:WeatherListService
    /// - Returns: Mock Endpoint error
    static func errorNoInternetEndpointClosure(_ target: WeatherListService) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: {
                            let afError: Alamofire.AFError = .sessionInvalidated(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet))
                            return .networkError(afError as NSError)
                        },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}
