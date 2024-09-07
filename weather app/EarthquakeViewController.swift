
//
//  EarthquakeViewController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//
import UIKit

class EarthquakeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var earthquakeData: [Earthquake] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        setGradientBackground()
        
        // TableView constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        fetchEarthquakeData()
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
    
    func fetchEarthquakeData() {
        let urlString = "https://api.orhanaydogdu.com.tr/deprem/kandilli/live"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(EarthquakeResponse.self, from: data)
                self?.earthquakeData = Array(result.result.prefix(100)) // First 100 earthquakes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch let jsonError {
                print("Failed to decode JSON: \(jsonError)")
            }
        }
        task.resume()
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let earthquake = earthquakeData[indexPath.row]
        let title = earthquake.title
        let magnitude = earthquake.mag
        let date = earthquake.date
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(title) - \(magnitude)\n\(date)"
        
        return cell
    }
}
