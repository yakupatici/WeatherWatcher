//
//  FavoritesViewController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//

import UIKit
enum TemperatureUnit: String {
    case celsius
    case fahrenheit
}
class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    var favoriteCities = [FavoriteCity]()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 64/255, green: 62/255, blue: 140/255, alpha: 1.0)
        return collectionView
    }()
    
    let noFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "Henüz favorilerinize bir şehir veya bölge eklemediniz. Eklemek için sağ üst köşeye gidin."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true // 
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        addTitleAndButton()
        setupCollectionView()
        setupNoFavoritesLabel()
        loadFavoriteCities()
        
    }
    
    func setGradientBackground() {
        let colorTop = UIColor(red: 64/255, green: 62/255, blue: 140/255, alpha: 1.0).cgColor
        let colorMiddle1 = UIColor(red: 52/255, green: 55/255, blue: 115/255, alpha: 1.0).cgColor
        let colorMiddle2 = UIColor(red: 37/255, green: 50/255, blue: 89/255, alpha: 1.0).cgColor
        let colorMiddle3 = UIColor(red: 27/255, green: 36/255, blue: 64/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 54/255, green: 54/255, blue: 119/255, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMiddle1, colorMiddle2, colorMiddle3, colorBottom]
        gradientLayer.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    func convertToPreferredUnit(_ temperatureInCelsius: String) -> String {
        let unit = TemperatureUnit(rawValue: UserDefaults.standard.string(forKey: "temperatureUnit") ?? "celsius") ?? .celsius
        guard let celsius = Double(temperatureInCelsius) else { return temperatureInCelsius }
        
        switch unit {
        case .celsius:
            return temperatureInCelsius
        case .fahrenheit:
            let fahrenheit = (celsius * 9/5) + 32
            return String(Int(round(fahrenheit)))
        }
    }

    
    func addTitleAndButton() {
        let titleLabel = UILabel()
        titleLabel.text = "Favoriler"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        ])
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = .white
        addButton.addTarget(self, action: #selector(addCity), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoriteCityCollectionViewCell.self, forCellWithReuseIdentifier: "favoriteCityCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        // Uzun Basma
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }

    
    func setupNoFavoritesLabel() {
        view.addSubview(noFavoritesLabel)
        
        noFavoritesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noFavoritesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavoritesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noFavoritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noFavoritesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func loadFavoriteCities() {
        if let savedCitiesData = UserDefaults.standard.array(forKey: "favoriteCities") as? [[String: String]] {
            favoriteCities = savedCitiesData.compactMap { dict in
                let name = dict["name"] ?? "Unknown City"
                let temperatureString = dict["temperature"] ?? "0"
                guard let temperature = Double(temperatureString) else {
                    print("Geçersiz derece: \(temperatureString)")
                    return nil
                }
                let temperatureRounded = String(Int(round(temperature))) // Dereceyi yuvarla
                let weatherIconName = dict["weatherIconName"] ?? "01d" // Use the new property
                
                return FavoriteCity(name: name, temperature: temperatureRounded, weatherIconName: weatherIconName) // Use the new property
            }
        }
        updateView()
    }

    
    func updateView() {
        collectionView.isHidden = favoriteCities.isEmpty
        noFavoritesLabel.isHidden = !favoriteCities.isEmpty
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCityCell", for: indexPath) as! FavoriteCityCollectionViewCell
        let city = favoriteCities[indexPath.item]
        cell.configure(with: city)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 20) / 2
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let city = favoriteCities[indexPath.item]
        let detailVC = CityDetailViewController()
        detailVC.city = city
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point), gestureRecognizer.state == .began {
            let city = favoriteCities[indexPath.item]
            let alert = UIAlertController(title: "Favorilerden Kaldır", message: "Favorilerinizden \(city.name)'i kaldırmak istiyor musunuz?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
            alert.addAction(UIAlertAction(title: "Kaldır", style: .destructive) { _ in
                self.favoriteCities.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath])
                
                // Save the updated favorite cities list
                let citiesData = self.favoriteCities.map { ["name": $0.name, "temperature": $0.temperature, "weatherIconName": $0.weatherIconName] }
                UserDefaults.standard.set(citiesData, forKey: "favoriteCities")
                
                self.updateView()
            })
            self.present(alert, animated: true)
        }
    }

    
    @objc func addCity() {
        let citySearchViewController = CitySearchViewController()
        citySearchViewController.onCityAdded = { [weak self] city in
            guard let self = self else { return }
            if !self.favoriteCities.contains(where: { $0.name == city }) {
                self.fetchWeatherData(for: city) { temperature, iconName, description in
                    let newCity = FavoriteCity(
                        name: city,
                        temperature: String(Int(round(temperature))), // Yuvarlanmış sıcaklık
                        weatherIconName: iconName
                       
                    )
                    self.favoriteCities.append(newCity)
                    self.favoriteCities.sort { $0.name < $1.name } // Alfabetik sıraya göre
                    self.collectionView.reloadData()
                    
                    // Güncellenmiş favori şehirler listesini kaydetme
                    let citiesData = self.favoriteCities.map { city in
                        return [
                            "name": city.name,
                            "temperature": city.temperature,
                            "weatherIconName": city.weatherIconName,
                            
                        ]
                    }
                    UserDefaults.standard.set(citiesData, forKey: "favoriteCities")
                    self.updateView() // Görünümü güncelle
                }
            } else {
                let alert = UIAlertController(title: "Daha önce eklendi", message: "\(city) şu an favorilerinizde", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
        navigationController?.pushViewController(citySearchViewController, animated: true)
    }

    func fetchWeatherData(for city: String, completion: @escaping (Double, String, String) -> Void) {
        let apiKey = "1082aea547f60691ff6e13114b25e759"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let temperature = weatherResponse.main.temp
                let description = weatherResponse.weather.first?.description ?? "No description"
                let iconName = self.iconName(for: description)
                DispatchQueue.main.async {
                    completion(temperature, iconName, description)
                }
            } catch {
                print("JSON parse error: \(error)")
            }
        }
        task.resume()
    }

    func fetchWeatherData(for city: String, completion: @escaping (Double, String) -> Void) {
        let apiKey = "1082aea547f60691ff6e13114b25e759"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let temperature = weatherResponse.main.temp
                let iconName = self.iconName(for: weatherResponse.weather.first?.description ?? "")
                DispatchQueue.main.async {
                    completion(temperature, iconName)
                }
            } catch {
                print("JSON parse error: \(error)")
            }
        }
        task.resume()
    }
    
    func iconName(for description: String) -> String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        if currentHour >= 19 || currentHour < 5 {
           if description.lowercased() == "clear sky"{
               return "01n"
                
            } };
       
        
        // Openweatherdan çekilen iconların isimleriyle döndürme işlemi
        switch description.lowercased() {
        case "clear sky":
            return "01d"
        case "few clouds":
            return "02d"
        case "scattered clouds":
            return "03d"
        case "broken clouds":
            return "04d"
        case "shower rain":
            return "09d"
        case "rain":
            return "10d"
        case "thunderstorm":
            return "11d"
        case "snow":
            return "13d"
        case "mist":
            return "50d"
        default:
            return "01d" // Varsayılan ikon
        }
    }

    
}
