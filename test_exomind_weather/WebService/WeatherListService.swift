//
//  WeatherListService.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//

import Moya

public enum WeatherListService {
    case weatherBy(nameCity: String)
}

extension WeatherListService: TargetType {

    /// task of requst
    public var task: Task {
        switch self {
        case .weatherBy(let nameCity):
            return .requestParameters(parameters: ["appid": Constant.apiKey, "q": nameCity, "units": Constant.apiUnit], encoding: URLEncoding.queryString)
        }
    }

    ///base url of request
    public var baseURL: URL {
        return URL(string: Constant.apiBase)!
    }

    ///path relatif
    public var path: String {
         return "/weather"
    }

    ///method of request
    public var method: Moya.Method {
        switch self {
        case .weatherBy:
            return .get
        }
    }

    ///headers of request
    public var headers: [String: String]? {
        return ["Content-Type": "application/json; charset=utf-8"]
    }

    ///type of validation
    public var validationType: ValidationType {
        return .successCodes
    }

    ///mock data for unit test
    public var sampleData: Data {
        switch self {
        case .weatherBy(let nameCity):
            guard let path = Bundle.main.path(forResource: nameCity, ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                return "".data(using: String.Encoding.utf8)!
            }
            return data
        }
    }
}
