//
//  CitiesViewController.swift
//  Weather
//
//  Created by mikhey on 28.06.2018.
//  Copyright © 2018 mikhey. All rights reserved.
//

import UIKit
import CoreData

class CitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var final2: String?
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var arrayForCollection = [String]()
    var arrayForCollectionCity = [City]()
//    var arr = [city]
    
    let openweatherMapBaseURL = "http:/api.openweathermap.org/data/2.5/weather"
    let openweatherMaAPIKey = "02e192611291898113072edd948bbe34"
    
    // StatusBar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayForCollection.append("Moscow")
        arrayForCollection.append("Kiev")
        
        for i in 0..<arrayForCollection.count{
            arrayForCollectionCity.append(City())
            arrayForCollectionCity[i].name = arrayForCollection[i]
            fetchJSON(city: arrayForCollectionCity[i].name!)
            //
        }
    }
    
    func fetchJSON(city: String) {
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

                    let found =  self.arrayForCollectionCity.index { (city1) -> Bool in
                        city1.name == city
                    }
                    if found != nil {
                        if decoder.main.temp != nil{
                            let temperature = Int(decoder.main.temp! - 273)
                            self.arrayForCollectionCity[found!].temp = String(temperature)
                        }
                        if decoder.weather[0].main != nil{
                            self.arrayForCollectionCity[found!].mainW = decoder.weather[0].main
                        }
                        if decoder.weather[0].description != nil{
                            self.arrayForCollectionCity[found!].dicriptW = decoder.weather[0].description
                        }
                    }
                } catch {
                    print("Error:\n\(error)")
                }
            }
            }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayForCollection.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CitiesCVC
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            cell.cityNameLabel.textColor = UIColor.white
            cell.cityNameLabel.text = self.arrayForCollectionCity[indexPath.item].name
            cell.cityTemp.text = (self.arrayForCollectionCity[indexPath.item].temp!) + "C"
            
            if self.arrayForCollectionCity[indexPath.item].mainW == "Clear" {
                if self.arrayForCollectionCity[indexPath.item].dicriptW == "clear sky" {
                   cell.cityImg.image = UIImage(named: "Weather3_Big")
                }
            }
            if self.arrayForCollectionCity[indexPath.item].mainW == "Clouds" {
                if self.arrayForCollectionCity[indexPath.item].dicriptW == "scattered clouds" {
                    cell.cityImg.image = UIImage(named: "Weather4_Big")
                }
                cell.cityImg.image = UIImage(named: "Weather1_Big")
            }
            if self.arrayForCollectionCity[indexPath.item].mainW == "Rain" {
                cell.cityImg.image = UIImage(named: "Weather5_Big")
            }
            if self.arrayForCollectionCity[indexPath.item].mainW == "Thunderstorm" {
                if self.arrayForCollectionCity[indexPath.item].dicriptW == "thunderstorm" {
                    cell.cityImg.image = UIImage(named: "Weather2_Big")
                }
            }
            
        })
        return cell
    }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! CityWhetherVC
//        vc.cityName = "indexPath"
        
    }
}

