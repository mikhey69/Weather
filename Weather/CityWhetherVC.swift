//
//  CityWhetherVC.swift
//  Weather
//
//  Created by mikhey on 28.06.2018.
//  Copyright © 2018 mikhey. All rights reserved.
//

import UIKit

var favoriteCities = [String]()

class CityWhetherVC: UIViewController {
    
    
    @IBOutlet weak var navRightButton: UIBarButtonItem!
    //
    @IBOutlet weak var mainWeatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    //
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    //
    @IBOutlet weak var chanceImage: UIImageView!
    @IBOutlet weak var chanceLabel: UILabel!
    //
    @IBOutlet weak var humidityImage: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    //images
    var windImg = UIImage(named: "Wind")
    var pressureImg = UIImage(named: "Rain_chance")
    var humidityImg = UIImage(named: "Humidity")
    
    //variable
    var cityName = "Moscow"
    
    //const
    let openweatherMapBaseURL = "http:/api.openweathermap.org/data/2.5/weather"
    let openweatherMaAPIKey = "02e192611291898113072edd948bbe34"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = cityName
    
        fetchJSON(city: cityName)
        refreshAddOrDelete()
        
    
    }
    
    
    //JSON
    
    fileprivate func fetchJSON(city: String) {
        let weatherURL = "\(openweatherMapBaseURL)?&q=\(city)&APPID=\(openweatherMaAPIKey)"
        guard let url = URL(string: weatherURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
             
                if let error = error {
                    print("Failed to get data from url:", error)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = try JSONDecoder().decode(Response.self, from: data)
//                    print(decoder)
                    self.setUpWeatherView(decoder)
                    self.setUpdateImages(decoder)
                    
                } catch {
                    print("Error:\n\(error)")
                }
            }
            }.resume()
    }
    
    fileprivate func setUpWeatherView(_ decoder: Response) {
        
        //labels
        if decoder.main.temp != nil{
            let temperature = Int(decoder.main.temp! - 273)
            self.temperatureLabel.text = String(temperature) + "C"
        }
        if decoder.wind.speed != nil {
            let windSpeed = Int(decoder.wind.speed!)
            self.windLabel.text = String(windSpeed) + "m/s"

        }
        if decoder.main.pressure != nil {
            let pressure = decoder.main.pressure!
            self.chanceLabel.text = String(pressure) + "hPa"
        }
        if decoder.main.humidity != nil {
            let humidity = decoder.main.humidity!
            self.humidityLabel.text = String(humidity) + "%"
        }

    }
    
    fileprivate func setUpdateImages(_ decoder: Response) {
        if windImg != nil {
            windImage.image = windImg
        }
        if pressureImg != nil {
            chanceImage.image = pressureImg
        }
        if humidityImg != nil {
            humidityImage.image = humidityImg
        }
        
        if decoder.weather[0].main == "Clear" {
            if decoder.weather[0].description == "clear sky" {
                mainWeatherImage.image = UIImage(named: "Weather3_Big")
            }
        }
        if decoder.weather[0].main == "Clouds" {
            if decoder.weather[0].description == "scattered clouds" {
                mainWeatherImage.image = UIImage(named: "Weather4_Big")
            }
                mainWeatherImage.image = UIImage(named: "Weather1_Big")
        }
        if decoder.weather[0].main == "Rain" {
                    mainWeatherImage.image = UIImage(named: "Weather5_Big")
        }
        if decoder.weather[0].main == "Thunderstorm" {
            if decoder.weather[0].description == "thunderstorm" {
                mainWeatherImage.image = UIImage(named: "Weather2_Big")
            }
        }
    }
    

    @IBAction func navRightButton(_ sender: Any) {
        
    }
    
    func refreshAddOrDelete() {
        
        if favoriteCities.contains(cityName) {
            navRightButton.image = UIImage(named: "Delete")
        } else {
            navRightButton.image = UIImage(named: "Add")
        }
    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let citiesViewController = segue.destination
        as! CitiesViewController
    

    if favoriteCities.contains(cityName) {
        favoriteCities = favoriteCities.filter{$0 != "\(cityName)"}
    } else {
        favoriteCities.append(cityName)
        
    }
    citiesViewController.arrayForCollection = favoriteCities
    }
}

