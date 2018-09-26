//
//  ForecastVC.swift
//  Paradise Lost
//
//  Created by jason on 21/4/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import UIKit

class ForecastVC: UIViewController, ForecastViewDelegate {
    private let darkskyLink = "https://api.darksky.net/forecast/"
    private let darkskyKey = "cb16118455c632ec0de548eda02d6570"
    
    var mainView: ForecastView!
    
    var manager = ForecastManager.shareInstance
    
    // TODO: use an array to save these info and add more cities
    var cityName: String = "GuangZhou"
    var latitude: Double = 23.12
    var longitude: Double = 113.25
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = ForecastView(frame: UIScreen.main.bounds)
        mainView.delegate = self
        mainView.setLocation(cityName: cityName, latitude: latitude, longitude: longitude)
        view.addSubview(mainView)
        
        // initial data
        updateView()
    }
    
    // MARK: ForecastViewDelegate
    
    func updateView() {
        let url = manager.getDarkSkyLink(latitude, longitude)
        getWeatherInfo(urlString: url)
    }
    
    // MARK: private methods
    
    fileprivate func getWeatherInfo(urlString: String) {
        //
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.mainView.busyLoading()
            }
        }
        let session = URLSession.shared
        let url = URL(string: urlString)
        let dataTask = session.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                // handle error
                print("error: \(String(describing: error))")
            } else {
                //print("result:\n\(String(data:data!, encoding: String.Encoding.utf8)!)")
                self.manager.setJSON(data: data)
                DispatchQueue.main.async {
                    self.refreshData()
                    self.mainView.endLoading()
                }
            }
        }
        // launch data task
        dataTask.resume()
    }
    
    fileprivate func refreshData() {
        mainView.setWeatherIcon(iconName: manager.getWeatherIcon())
        mainView.setTime(date: manager.getTime())
        mainView.setSummary(summary: manager.getSummary())
        mainView.setTemperature(temperature: manager.getTemperature(inCelsius: true), isCelsius: true)
    }
}
