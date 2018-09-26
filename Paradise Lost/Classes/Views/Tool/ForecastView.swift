//
//  ForecastView.swift
//  Paradise Lost
//
//  Created by jason on 21/4/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import UIKit
import SnapKit

protocol ForecastViewDelegate {
    func updateView()
}

class ForecastView: UIView {
    
    var delegate: ForecastViewDelegate? = nil
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        addSubview(weatherIcon)
        addSubview(updateButton)
        addSubview(actIndView)
        addSubview(locationLabel)
        addSubview(timeLabel)
        addSubview(timeText)
        addSubview(summaryLabel)
        addSubview(summaryText)
        addSubview(temperatureLabel)
        addSubview(temperatureText)
        
        updateButton.addTarget(self, action: #selector(ForecastView.doUpdate), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        actIndView.snp.makeConstraints { (make) in
            make.width.equalTo(144)
            make.height.equalTo(144)
            make.left.equalTo(self).offset(8)
            make.top.equalTo(self).offset(84)
        }
        weatherIcon.snp.makeConstraints { (make) in
            make.width.equalTo(144)
            make.height.equalTo(144)
            make.left.equalTo(self).offset(8)
            make.top.equalTo(self).offset(84)
        }
        updateButton.snp.makeConstraints { (make) in
            make.left.equalTo(actIndView.snp.right).offset(8)
            make.right.equalTo(self).offset(-8)
            make.top.equalTo(actIndView)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(actIndView.snp.right).offset(8)
            make.right.equalTo(self).offset(-8)
            make.bottom.equalTo(actIndView.snp.bottom)
            make.height.equalTo(20)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.top.equalTo(actIndView.snp.bottom).offset(35)
            make.width.equalTo(150)
        }
        timeText.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(8)
            make.top.equalTo(timeLabel)
            make.height.equalTo(timeLabel)
            make.right.equalTo(self).offset(-8)
        }
        summaryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.width.equalTo(150)
        }
        summaryText.snp.makeConstraints { (make) in
            make.left.equalTo(summaryLabel.snp.right).offset(8)
            make.top.equalTo(summaryLabel)
            make.height.equalTo(summaryLabel)
            make.right.equalTo(self).offset(-8)
        }
        temperatureLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.top.equalTo(summaryLabel.snp.bottom).offset(8)
            make.width.equalTo(150)
        }
        temperatureText.snp.makeConstraints { (make) in
            make.left.equalTo(temperatureLabel.snp.right).offset(8)
            make.top.equalTo(temperatureLabel)
            make.height.equalTo(temperatureLabel)
            make.right.equalTo(self).offset(-8)
        }
    }
    
    // MARK: event response
    
    func doUpdate() {
        delegate?.updateView()
    }
    
    func busyLoading() {
        weatherIcon.isHidden = true
        actIndView.startAnimating()
    }
    
    func endLoading() {
        weatherIcon.isHidden = false
        actIndView.stopAnimating()
    }
    
    func setWeatherIcon(iconName: String?) {
        if let name = iconName, let icon = UIImage(named: name) {
            weatherIcon.image = icon
        } else {
            weatherIcon.image = UIImage()
        }
    }
    
    func setLocation(cityName: String, latitude: Double, longitude: Double) {
        locationLabel.text = "\(cityName) - \(String(format: "%.2f", latitude)), \(String(format: "%.2f", longitude))"
    }
    
    func setTime(date: Date?) {
        if let t = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            timeText.text = dateFormatter.string(from: t)
        } else {
            timeText.text = "-"
        }
    }
    
    func setSummary(summary: String?) {
        if let s = summary {
            summaryText.text = s
        } else {
            summaryText.text = "-"
        }
    }
    
    func setTemperature(temperature: Double?, isCelsius: Bool) {
        if let temp = temperature {
            if isCelsius {
                temperatureText.text = "\(String(format:"%.2f", temp)) \u{2103}" // degree celsius
            } else {
                temperatureText.text = "\(String(format:"%.2f", temp)) \u{2109}" // degree fahrenheit
            }
        } else {
            temperatureText.text = "-"
        }
    }
    
    // MARK: getters and setters
    
    fileprivate var actIndView: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    fileprivate var updateButton: UIButton = {
        var button = UIButton(type: .system)
        button.titleLabel?.textAlignment = .right
        button.setTitle("update", for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var weatherIcon: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate var locationLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var timeLabel: UILabel = {
        var label = UILabel()
        label.text = "Time:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var timeText: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var summaryLabel: UILabel = {
        var label = UILabel()
        label.text = "Summary:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var summaryText: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var temperatureLabel: UILabel = {
        var label = UILabel()
        label.text = "Temperature:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var temperatureText: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
