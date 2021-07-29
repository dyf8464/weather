//
//  WeatherViewController.swift
//  test_exomind_weather
//
//  Created by zhizi yuan on 28/07/2021.
//

import UIKit
import RxCocoa
import RxSwift

class WeatherListViewController: UIViewController {

    /// progressive view for download
    @IBOutlet var progressive: UIProgressView!

    /// percentage progressive view
    @IBOutlet var percentLabel: UILabel!

    /// indicator during download
    @IBOutlet var indicator: UILabel!

    /// tableview for display the weathers
    @IBOutlet var tableView: UITableView!

    /// button for restart download
    @IBOutlet var restartButton: UIButton!

    /// title of progressvie view
    @IBOutlet var titleProgressiveLabel: UILabel!

    /// button for close WeatherListViewController
    @IBOutlet var closeButton: UIButton!

    /// viewModel for control download weathers
    var viewModel: WeatherListViewModel = WeatherListViewModel()

    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        //configure tableview
        self.setUpTableView()

        //configure call back and rx bind with viewModel
        self.viewModelCallbacks()

        //download weathers
        self.startDownloadWeathers()

        //action for click restart button
        self.restartButton.rx.tap.subscribe(onNext: {
            self.startDownloadWeathers()
        }).disposed(by: disposeBag)

        //aciton for click close button
        self.closeButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)

    }

    ///download weathers
    private func startDownloadWeathers() {
        viewModel.downloadWeathers(progressViewBinder: progressive.rx.progress, indicatorBinder: indicator.rx.text, percentBinder: percentLabel.rx.text)
    }

    ///update UI according to dowloading
    private func isDownloading(downloading: Bool) {
        self.percentLabel.isHidden = !downloading
        self.progressive.isHidden = !downloading
        self.titleProgressiveLabel.isHidden = !downloading
        self.restartButton.isHidden = downloading
    }

    ///display alert message
    private func displayAlertMessage(alertMessage: AlertMessage) {
        let alertController = UIAlertController(title: alertMessage.title, message: alertMessage.message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Fermer", style: .cancel)
        alertController.addAction(closeAction)

        let retryAction = UIAlertAction(title: "Réessayer", style: .default) { _ in
            self.startDownloadWeathers()
        }
        alertController.addAction(retryAction)

        present(alertController, animated: true)
    }

}

// MARK: - ViewModel
extension WeatherListViewController {

    ///configure call back and rx bind with viewModel
    private func viewModelCallbacks() {
        viewModel.indicatorTextBehaviorRelay.bind(to: self.indicator.rx.text).disposed(by: disposeBag)
        viewModel.downloadingBehaviorRelay.observeOn(MainScheduler.instance).subscribe {
            self.isDownloading(downloading: $0)
        }.disposed(by: disposeBag)

        viewModel.alertMessagePublishSubjet.observeOn(MainScheduler.instance).subscribe {
            self.displayAlertMessage(alertMessage: $0)
        }.disposed(by: disposeBag)
    }
}

// MARK: - tableView
extension WeatherListViewController {

    ///configure table view and table cell
    private func setUpTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(WeatherTableViewCell.nib, forCellReuseIdentifier: WeatherTableViewCell.id)
        viewModel.weatherViewModelListBehaviorRelay.bind(to: tableView.rx.items) { tableView, _, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.id)
                as? WeatherTableViewCell else {
                return UITableViewCell()
            }
            cell.loadViewModel(viewModel: element)
            return cell
        }.disposed(by: disposeBag)
    }

}
