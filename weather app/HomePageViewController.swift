//
//  HomePageViewController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atici on 20.03.2025.
//

//
// HomePageViewController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cityNameLabel = UILabel()
    let temperatureLabel = UILabel()
    let weatherIconImageView = UIImageView()
    let descriptionLabel = UILabel()
    let minMaxLabel = UILabel()
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    let sunImageView = UIImageView(image: UIImage(named: "01d"))
    
    let weatherDetails = ["Hava Kalitesi", "Nem", "Rüzgar Hızı", "Basınç"]
    
    lazy var detailsCollectionView: UICollectionView = {
        // UICollectionViewFlowLayout, koleksiyon görünümünün düzenini belirler
        let layout = UICollectionViewFlowLayout()
        
        // Koleksiyon görünümünün yatay kaydırma yönü olacağını belirtir
        layout.scrollDirection = .horizontal
        
        // Hücreler arasındaki minimum boşluk
        layout.minimumLineSpacing = 10
        
        // Hücrelerin genişlik ve yükseklik boyutlarını ayarlar
        layout.itemSize = CGSize(width: 110, height: 120)
        
        // Koleksiyon görünümünü oluşturur ve yukarıda tanımlanan düzeni kullanır
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Otomatik boyutlandırma kullanımı kapatılır ve kısıtlamalar kullanılabilir hale gelir
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Koleksiyon görünümünün arka plan rengini şeffaf yapar
        collectionView.backgroundColor = .clear
        
        // Koleksiyon görünümünün delege ve veri kaynağını bu sınıf olarak ayarlar
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Yatay kaydırma çubuğunu gizler
        collectionView.showsHorizontalScrollIndicator = false
        
        // Hücrelerin `WeatherDetailCell` sınıfından olduğunu ve bu hücreler için bir yeniden kullanım kimliği tanımlar
        collectionView.register(WeatherDetailCell.self, forCellWithReuseIdentifier: "WeatherDetailCell")
        
        // Koleksiyon görünümünü döndürür
        return collectionView
    }()
    
    let locationLabel = UILabel()
    
    var weatherData: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        addImageViewAndLabel()
        setupCollectionView()
        setupLocationLabel()
        setupLocationManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChanged), name: Notification.Name("SettingsChanged"), object: nil)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 1 // 10 metre
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @objc func settingsChanged() {
        if let location = locationManager.location {
            fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
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

    func addImageViewAndLabel() {
        sunImageView.contentMode = .scaleAspectFit
        
        cityNameLabel.textColor = .white
        cityNameLabel.textAlignment = .center
        cityNameLabel.font = UIFont.systemFont(ofSize: 36)
        
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.systemFont(ofSize: 36)
        
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 24)
        
        minMaxLabel.textColor = .white
        minMaxLabel.textAlignment = .center
        minMaxLabel.font = UIFont.systemFont(ofSize: 18)
        
        weatherIconImageView.contentMode = .scaleAspectFit
        
        view.addSubview(sunImageView)
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(minMaxLabel)
        view.addSubview(weatherIconImageView)
        
        sunImageView.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sunImageView.widthAnchor.constraint(equalToConstant: 100),
            sunImageView.heightAnchor.constraint(equalToConstant: 100),
            sunImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            sunImageView.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: -50),
            
            cityNameLabel.topAnchor.constraint(equalTo: sunImageView.bottomAnchor, constant: 10),
            cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            minMaxLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            minMaxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 150),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 150),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.topAnchor.constraint(equalTo: minMaxLabel.bottomAnchor, constant: 20)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(detailsCollectionView)
        
        NSLayoutConstraint.activate([
            detailsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            detailsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            detailsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            detailsCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func setupLocationLabel() {
        locationLabel.textColor = .white
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont.systemFont(ofSize: 16)
        locationLabel.text = "Konumunuz"
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDetails.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherDetailCell", for: indexPath) as! WeatherDetailCell
        
        let title = weatherDetails[indexPath.row]
        let value = weatherData[title] ?? "-"
        
        let imageName: String
        switch title {
        case "Hava Kalitesi":
            imageName = "leaf.fill"
        case "Nem":
            imageName = "humidity-2"
        case "Rüzgar Hızı":
            imageName = "wind"
        case "Basınç":
            imageName = "pressure1"
        default:
            imageName = "default_icon"
        }
        
        let image = UIImage(named: imageName)
        cell.configure(with: title, value: value, image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func startSunAnimation() {
        let sunAnimation = CABasicAnimation(keyPath: "position.x")
        sunAnimation.fromValue = -50
        sunAnimation.toValue = view.bounds.width + 50
        sunAnimation.duration = 10
        sunAnimation.repeatCount = Float.infinity
        sunImageView.layer.add(sunAnimation, forKey: "sunAnimation")
    }

    func fetchWeatherData(latitude: Double, longitude: Double) {
        let apiKey = "1082aea547f60691ff6e13114b25e759"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.cityNameLabel.text = weatherResponse.name

                    let temperatureUnit = UserDefaults.standard.integer(forKey: "temperatureUnit")
                    let windUnit = UserDefaults.standard.integer(forKey: "windUnit")

                    switch temperatureUnit {
                    case 0: // Celsius
                        self.temperatureLabel.text = "\(Int(weatherResponse.main.temp))°C"
                    case 1: // Fahrenheit
                        let fahrenheitTemp = (weatherResponse.main.temp * 9/5) + 32
                        self.temperatureLabel.text = "\(Int(fahrenheitTemp))°F"
                    default:
                        self.temperatureLabel.text = "\(Int(weatherResponse.main.temp))°C"
                    }

                    let iconCode = weatherResponse.weather.first?.icon ?? "default"
                    self.weatherIconImageView.image = UIImage(named: iconCode)

                    let description = self.descriptionInTurkish(for: weatherResponse.weather.first?.description ?? "")
                    self.descriptionLabel.text = description

                    let (minTemp, maxTemp) = self.convertTemperature(min: weatherResponse.main.temp_min, max: weatherResponse.main.temp_max, unit: temperatureUnit)
                    self.minMaxLabel.text = "Max: \(Int(maxTemp))°, Min: \(Int(minTemp))°"

                    let windSpeed = windUnit == 0 ? weatherResponse.wind.speed : weatherResponse.wind.speed * 2.237
                    let windSpeedUnit = windUnit == 0 ? "m/s" : "mph"

                    self.weatherData = [
                        "Hava Kalitesi": "İyi",
                        "Nem": "\(weatherResponse.main.humidity)%",
                        "Rüzgar Hızı": String(format: "%.1f %@", windSpeed, windSpeedUnit),
                        "Basınç": "\(weatherResponse.main.pressure) hPa"
                    ]

                    self.detailsCollectionView.reloadData()

                    if let weather = weatherResponse.weather.first {
                        let description = weather.description.lowercased()
                        if description.contains("rain") || description.contains("shower") {
                            self.sendRainNotification()
                        }
                    }
                }
            } catch {
                print("JSON ayrıştırma hatası: \(error)")
            }
        }
        task.resume()
    }

    func sendRainNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Dikkat!"
        content.body = "Hey, yağmur yağabilir. Şemsiyeni almayı unutma 🌧️☔️!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim gönderme hatası: \(error)")
            }
        }
    }

    func convertTemperature(min: Double, max: Double, unit: Int) -> (Double, Double) {
        switch unit {
        case 0: // Celsius
            return (min, max)
        case 1: // Fahrenheit
            return ((min * 9/5) + 32, (max * 9/5) + 32)
        default:
            return (min, max)
        }
    }

    func iconName(for weatherDescription: String) -> String {
        return weatherDescription
    }

    func descriptionInTurkish(for weatherDescription: String) -> String {
        switch weatherDescription.lowercased() {
        case "clear sky":
            return "Açık Hava"
        case "few clouds":
            return "Az Bulutlu"
        case "scattered clouds":
            return "Dağınık Bulutlar"
        case "broken clouds":
            return "Parçalı Bulutlu"
        case "shower rain":
            return "Yağmur"
        case "rain":
            return "Yağışlı"
        case "thunderstorm":
            return "Gök Gürültülü"
        case "snow":
            return "Karla Karışık"
        case "mist":
            return "Sisli"
        default:
            return "Bilinmeyen Hava Durumu"
        }
    }

 

    // CLLocationManagerDelegate metotları
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Konumun doğruluğunu kontrol edin
        if location.horizontalAccuracy < 100 {
            // Konum güncellemelerini durdurun
            locationManager.stopUpdatingLocation()

            // Hava durumu verilerini fetch edin
            fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            // Konumu tersine geocode edin
            reverseGeocodeLocation(location: location)
        }
    }


    func reverseGeocodeLocation(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocode işleminde hata oluştu: \(error.localizedDescription)")
                return
            }

            guard let placemark = placemarks?.first else {
                print("Geocode sonucu bulunamadı")
                return
            }

            let city = placemark.locality ?? "Bilinmeyen Şehir"
            let administrativeArea = placemark.administrativeArea ?? "Bilinmeyen İl"
            let country = placemark.country ?? "Bilinmeyen Ülke"
            
            // Adres bilgilerini yazdırın veya UI'ye ekleyin
            print("Şehir: \(city)")
            print("İl: \(administrativeArea)")
            print("Ülke: \(country)")

            // Örneğin, şehir adını bir label'a atayabilirsiniz
            DispatchQueue.main.async {
                self.cityNameLabel.text = city
            }
        }
    }



    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Konum bilgisi alınamadı: \(error)")
    }}

class WeatherDetailCell: UICollectionViewCell {
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            valueLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    func configure(with title: String, value: String, image: UIImage?) {
        titleLabel.text = title
        valueLabel.text = value
        iconImageView.image = image
    }
}
