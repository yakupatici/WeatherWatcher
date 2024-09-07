//
//  CityDetailViewController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//

import UIKit


class CityDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var city: FavoriteCity?
        var days: [String] = []
        var temperatures: [String] = []
        var weatherDescriptions: [String] = []  // Günlük hava durumu açıklamaları
        var weatherIcons: [String] = []
    
              var uvIndex: [String] = []
              var windSpeed: [String] = []
              var humidity: [String] = []
              var pressure: [String] = []
    var airQuality: [String] = []
    // Günlük sıcaklıkları depolamak için bir dizi 
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let gridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupLabels()
        setupCollectionView()
        setupGridView()
        generateDays()
        fetchWeatherData() // Veriyi çekmek için yeni fonksiyon
        
        if let city = city {
            cityNameLabel.text = city.name
            temperatureLabel.text = "\(city.temperature)°C"
        }
    }
    
    private func setGradientBackground() {
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
    
    private func setupLabels() {
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureLabel)
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 200) // Adjusted height
        ])
    }
    
    private func setupGridView() {
        gridView.delegate = self
        gridView.dataSource = self
        gridView.register(ForecastGridViewCell.self, forCellWithReuseIdentifier: "gridCell")
        view.addSubview(gridView)
        
        gridView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    private func generateDays() {
        let calendar = Calendar.current
        let today = Date()
        
        var dayNames: [String] = []
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE" // Tam hafta günü ismi
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                let dayName = formatter.string(from: date)
                dayNames.append(dayName.capitalized)
            }
        }
        
        days = dayNames
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
                return "Sağanak Yağmur"
            case "rain":
                return "Yağışlı"
            case "thunderstorm":
                return "Gök Gürültülü"
            case "snow":
                return "Karla Karışık"
            case "mist":
                return "Sisli"
            case "overcast clouds":
                return "Kapalı Bulutlu"
            case "light rain":
                return "Hafif Yağmur"
            case "moderate rain":
                return "Orta Şiddetli Yağmur"
            case "heavy intensity rain":
                return "Yoğun Yağmur"
            case "very heavy rain":
                return "Çok Yoğun Yağmur"
            case "extreme rain":
                return "Aşırı Yağmur"
            case "freezing rain":
                return "Dondurucu Yağmur"
            case "light snow":
                return "Hafif Kar Yağışı"
            case "heavy snow":
                return "Yoğun Kar Yağışı"
            case "sleet":
                return "Sulu Kar"
            case "shower sleet":
                return "Sağanak Sulu Kar"
            case "light shower sleet":
                return "Hafif Sağanak Sulu Kar"
            case "light shower rain":
                return "Hafif Sağanak Yağmur"
            case "ragged shower rain":
                return "Parçalı Sağanak Yağmur"
            default:
                return "Bilinmeyen Hava Durumu"
        }
        }
    private func fetchWeatherData() {
        guard let cityName = city?.name else { return }
        let apiKey = "1082aea547f60691ff6e13114b25e759"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data:", error)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let list = json["list"] as? [[String: Any]] {
                    
                    // Clear previous data
                    self.days.removeAll()
                    self.temperatures.removeAll()
                    self.weatherDescriptions.removeAll()
                    self.weatherIcons.removeAll()
                    self.airQuality.removeAll()
                    self.windSpeed.removeAll()
                    self.humidity.removeAll()
                    self.pressure.removeAll()

                    let calendar = Calendar.current
                    var dailyData = [Date: (temp: Double, description: String, icon: String, windSpeed: Double, humidity: Int, pressure: Int, airQuality: String)]()

                    for item in list {
                        if let dt = item["dt"] as? TimeInterval,
                           let main = item["main"] as? [String: Any],
                           let temp = main["temp"] as? Double,
                           let humidityValue = main["humidity"] as? Int,
                           let pressureValue = main["pressure"] as? Int,
                           let weatherArray = item["weather"] as? [[String: Any]],
                           let weather = weatherArray.first,
                           let description = weather["description"] as? String,
                           let icon = weather["icon"] as? String,
                           let wind = item["wind"] as? [String: Any],
                           let windSpeedValue = wind["speed"] as? Double {
                            
                            let date = Date(timeIntervalSince1970: dt)
                            let components = calendar.dateComponents([.year, .month, .day], from: date)
                            let startOfDay = calendar.date(from: components)

                            if calendar.component(.hour, from: date) == 12 {
                                if dailyData[startOfDay ?? date] == nil {
                                    dailyData[startOfDay ?? date] = (temp: temp, description: description, icon: icon, windSpeed: windSpeedValue, humidity: humidityValue, pressure: pressureValue, airQuality: "İyi") // Default air quality
                                }
                            }
                        }
                    }

                    let sortedDays = dailyData.keys.sorted()
                    self.days = sortedDays.map { date in
                        let formatter = DateFormatter()
                        formatter.dateFormat = "EEEE"
                        return formatter.string(from: date)
                    }

                    self.temperatures = sortedDays.map { date in
                        let temp = dailyData[date]?.temp ?? 0
                        return "\(Int(temp))°C"
                    }

                    self.weatherDescriptions = sortedDays.map { date in
                        return dailyData[date]?.description ?? "No description"
                    }

                    self.weatherIcons = sortedDays.map { date in
                        return dailyData[date]?.icon ?? "01d"
                    }

                    self.windSpeed = sortedDays.map { date in
                        return "\(dailyData[date]?.windSpeed ?? 0) m/s"
                    }
                    self.humidity = sortedDays.map { date in
                        return "\(dailyData[date]?.humidity ?? 0)%"
                    }
                    self.pressure = sortedDays.map { date in
                        return "\(dailyData[date]?.pressure ?? 0) hPa"
                    }
                    self.airQuality = sortedDays.map { date in
                        return dailyData[date]?.airQuality ?? "Good" // Placeholder, replace with real data if available
                    }

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.gridView.reloadData()
                    }
                } else {
                    print("Error: Unexpected JSON format")
                }
            } catch {
                print("Error parsing JSON:", error)
            }
        }

        task.resume()
    }

    
    // MARK: - UICollectionView DataSource and Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionView ? days.count : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if collectionView == self.collectionView {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ForecastCollectionViewCell
               let iconCode = (indexPath.item < weatherIcons.count) ? weatherIcons[indexPath.item] : "01d"
               let description = (indexPath.item < weatherDescriptions.count) ? descriptionInTurkish(for: weatherDescriptions[indexPath.item]) : "Bilinmeyen Hava Durumu"
               let temperature = (indexPath.item < temperatures.count) ? temperatures[indexPath.item] : "--°C"
               let day = (indexPath.item < days.count) ? days[indexPath.item] : "Unknown"
               
               cell.weatherIconImageView.image = UIImage(named: iconCode)
               cell.descriptionLabel.text = description
               cell.dayLabel.text = day
               cell.temperatureLabel.text = temperature
               
               return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! ForecastGridViewCell
            
            // Check index range before accessing arrays
            if indexPath.item < airQuality.count {
                switch indexPath.item {
                case 0:
                    cell.iconImageView.image = UIImage(named: "leaf.fill")
                    cell.titleLabel.text = "Hava Kalitesi"
                    cell.valueLabel.text = airQuality[indexPath.item]
                case 1:
                    cell.iconImageView.image = UIImage(named: "wind")
                    cell.titleLabel.text = "Rüzgar Hızı"
                    cell.valueLabel.text = windSpeed[indexPath.item]
                case 2:
                    cell.iconImageView.image = UIImage(named: "humidity-2")
                    cell.titleLabel.text = "Nem"
                    cell.valueLabel.text = humidity[indexPath.item]
                case 3:
                    cell.iconImageView.image = UIImage(named: "pressure1")
                    cell.titleLabel.text = "Basınç"
                    cell.valueLabel.text = pressure[indexPath.item]
                default:
                    break
                }
            } else {
                cell.titleLabel.text = "N/A"
                cell.valueLabel.text = "N/A"
            }
            
            return cell
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: (collectionView.bounds.width - 30) / 2, height: 100)
        } else {
            let width = (collectionView.bounds.width - 30) / 2
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}


// Custom UICollectionViewCell for forecast
class ForecastCollectionViewCell: UICollectionViewCell {
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(descriptionLabel)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            temperatureLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5),
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            weatherIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            weatherIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 50), // Simge genişliği
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 50), // Simge yüksekliği
            
            descriptionLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Custom UICollectionViewCell for grid
// Custom UICollectionViewCell for grid
class ForecastGridViewCell: UICollectionViewCell {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
}
