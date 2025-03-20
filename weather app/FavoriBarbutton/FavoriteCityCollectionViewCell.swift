//
//  FavoritesCityCollectionView.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//

import UIKit
class FavoriteCityCollectionViewCell: UICollectionViewCell {
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(weatherIconImageView)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5),
            cityLabel.trailingAnchor.constraint(equalTo: weatherIconImageView.leadingAnchor, constant: -10),
            
            weatherIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 40),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with city: FavoriteCity) {
        cityLabel.text = city.name
        temperatureLabel.text = "\(city.temperature)°C"
        
        weatherIconImageView.image = UIImage(named: city.weatherIconName) // Use the icon name
    }
}
