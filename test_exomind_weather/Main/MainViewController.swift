//
//  ViewController.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func launchWeatherViewController(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeatherListViewController")
        self.present(vc, animated: true)
    }
}
