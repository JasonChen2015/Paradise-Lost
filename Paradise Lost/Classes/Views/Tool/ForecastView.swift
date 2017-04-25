//
//  ForecastView.swift
//  Paradise Lost
//
//  Created by jason on 21/4/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import UIKit

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
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(144)]-[v1]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": weatherIcon, "v1": locationLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(144)]-[v1]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actIndView, "v1": updateButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(150)]-[v1]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeLabel, "v1": timeText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(150)]-[v1]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": summaryLabel, "v1": summaryText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(150)]-[v1]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": temperatureLabel, "v1": temperatureText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[v0(144)]-35-[v1]-[v2]-[v3]", options: NSLayoutFormatOptions(), metrics: nil,  views: ["v0": weatherIcon, "v1": timeLabel, "v2": summaryLabel, "v3": temperatureLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[v0(20)]-104-[v1(20)]-35-[v2]-[v3]-[v4]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": updateButton, "v1": locationLabel, "v2": timeText, "v3": summaryText, "v4": temperatureText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[v0(144)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actIndView]))
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
        var activity = UIActivityIndicatorView()
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
