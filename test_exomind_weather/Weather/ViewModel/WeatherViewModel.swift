//
//  WeatherViewModel.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//

import Foundation
protocol WeatherViewModel {
    var nameCityVM: String {get}
    var temperatureVM: String {get}
    var cloudsVM: String {get}
}

extension WeatherModel: WeatherViewModel {

    ///name of city
    var nameCityVM: String {
        nameCity ?? ""
     }

    ///temperature Celsius
    var temperatureVM: String {
        guard let temp = temperature else {
            return ""
        }
        return "\(temp) °C"
    }

    /// clouds percentage 
    var cloudsVM: String {
        guard let clouds = clouds else {
            return ""
        }
        return "\(clouds) %"
    }
}
