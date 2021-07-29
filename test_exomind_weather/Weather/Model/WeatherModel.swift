//
//  WeatherModel.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//

import ObjectMapper
struct WeatherModel: Mappable {
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        nameCity    <- map["name"]
        temperature    <- map["main.temp"]
        clouds    <- map["clouds.all"]
    }

  var nameCity: String?
  var temperature: Float?
  var clouds: Int?
}
