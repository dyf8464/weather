//
//  WeatherTableViewCell.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cloudLabel: UILabel!

    /// load element UI by viewModel
    /// - Parameter viewModel: needed viewModel for update cell
    func loadViewModel(viewModel: WeatherViewModel) {
        self.cityLabel.text = viewModel.nameCityVM
        self.temperatureLabel.text = viewModel.temperatureVM
        self.cloudLabel.text = viewModel.cloudsVM
    }

}
