//
//  CitySearchViewController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//

import UIKit

protocol CitySearchViewControllerDelegate: AnyObject {
    func didAddCityToFavorites(_ city: String)
}

class CitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let cities: [String] = [
        
        "Istanbul","Ankara","Izmir","Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Aksaray", "Amasya", "Antalya",
        "Ardahan", "Artvin", "Aydın", "Balıkesir", "Bartın", "Batman", "Bayburt", "Bilecik",
        "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum",
        "Denizli", "Diyarbakır", "Düzce", "Edirne", "Elazığ", "Erzincan", "Erzurum",
        "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkâri", "Hatay", "Iğdır",
        "Isparta", "Kahramanmaraş", "Karabük", "Karaman", "Kars",
        "Kastamonu", "Kayseri", "Kırıkkale", "Kırklareli", "Kırşehir", "Kilis", "Kocaeli",
        "Konya", "Kütahya", "Malatya", "Manisa", "Mardin", "Mersin", "Muğla", "Muş",
        "Nevşehir", "Niğde", "Ordu", "Osmaniye", "Rize", "Sakarya", "Samsun", "Siirt",
        "Sinop", "Sivas", "Şanlıurfa", "Şırnak", "Tekirdağ", "Tokat", "Trabzon", "Tunceli",
        "Uşak", "Van", "Yalova", "Yozgat", "Zonguldak",
        
        
        "New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose",
        "London", "Paris", "Berlin", "Madrid", "Rome", "Amsterdam", "Vienna", "Brussels", "Zurich", "Geneva",
        "Tokyo", "Seoul", "Beijing", "Shanghai", "Hong Kong", "Singapore", "Sydney", "Melbourne", "Toronto", "Vancouver",
        "Dubai", "Mumbai", "Delhi", "Bangkok", "Kuala Lumpur", "Jakarta", "Manila", "Buenos Aires", "São Paulo", "Lima",
        "Santiago", "Bogotá", "Rio de Janeiro", "Moscow", "Saint Petersburg", "Warsaw", "Prague", "Budapest", "Lisbon",
        "Athens", "Rome", "Naples", "Milan", "Zurich", "Geneva", "Monaco", "Stockholm", "Oslo", "Copenhagen",
        "Helsinki", "Dublin", "Edinburgh", "Glasgow", "Belfast", "Doha", "Kuwait City", "Jeddah", "Riyadh", "Tel Aviv",
        "Jerusalem", "Abu Dhabi", "Manama", "Muscat", "Sharjah", "Alexandria", "Cairo", "Casablanca", "Tangier", "Tunis",
        "Algiers", "Rabat", "Lagos", "Accra", "Nairobi", "Johannesburg", "Cape Town", "Durban", "Addis Ababa", "Khartoum",
        "Kampala", "Harare", "Luanda", "Maputo", "Victoria", "Canberra", "Perth", "Adelaide", "Brisbane", "Hobart",
        "Wellington", "Auckland", "Christchurch", "Suva", "Port Moresby", "Honiara", "Nuku'alofa", "Apia", "Tarawa",
        "Funafuti", "Majuro", "Yaren", "Palikir", "Ngerulmud", "Koror", "Dili", "Bali", "Yogyakarta", "Surabaya",
        "Bandung", "Medan", "Palembang", "Makassar", "Vientiane", "Hanoi", "Ho Chi Minh City", "Phnom Penh", "Yangon",
        "Dhaka", "Colombo", "Male", "Thimphu", "Kathmandu"
    ]
    
    // Başlık
    func addTitleAndButton() {
        let titleLabel = UILabel()
        titleLabel.text = "Şehir Seçimi"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -37)
        ])}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTitleAndButton()
        setupSearchBar()
        setupTableView()
        setGradientBackground()
        fetchCities()
        showInstructionsAlert()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // View tamamen görünür olduğunda alert
        showAlert()
    }
    func showAlert() {
        // `UIAlertController`'ı ana thread
        DispatchQueue.main.async {
            if self.isViewLoaded && self.view.window != nil {
                let alert = UIAlertController(title: "Bilgi", message: "Favorileriniz eklemek istediğiniz şehri yana kaydırın ve 'Ekle' tuşuna basınız.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var filteredCities = [String]()
    var onCityAdded: ((String) -> Void)? //
    var favoriteCities = Set<String>() //
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    
    
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
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Şehir Arayınız"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundImage = UIImage()
        
        let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchBarTextField?.backgroundColor = UIColor(white: 1, alpha: 0.3)
        searchBarTextField?.textColor = .white
        
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.separatorColor = .white
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func fetchCities() {
        filteredCities = cities
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = filteredCities[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCities = cities
        } else {
            filteredCities = cities.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let city = filteredCities[indexPath.row]
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            if self.favoriteCities.contains(city) {
                
                let alert = UIAlertController(title: "Favorilerde Mevcut", message: "\(city) favorilerinizde mevcut", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
               
                self.favoriteCities.insert(city)
                self.onCityAdded?(city)
                
                // Show alert
                let alert = UIAlertController(title: "Favorilere Ekle", message: "\(city) Favorilerinize eklendi.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            completionHandler(true)
        }
        
        favoriteAction.backgroundColor = UIColor.red
        favoriteAction.title = "Ekle"
        
        let swipeActions = UISwipeActionsConfiguration(actions: [favoriteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
    
    func showInstructionsAlert() {
        // UserDefaults'da işareti kontrol etme
        let hasShownInstructions = UserDefaults.standard.bool(forKey: "hasShownInstructions")
        
        // Eğer işaret yoksa (yani kullanıcı daha önce mesajı görmemişse)
        if !hasShownInstructions {
            let alert = UIAlertController(title: "Favoriler", message: "Favorileriniz eklemek istediğiniz şehri yana kaydırın ve 'Ekle' tuşuna basınız.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            
            // Mesaj gösterildikten sonra işareti UserDefaults'a kaydet
            UserDefaults.standard.set(true, forKey: "hasShownInstructions")
            
            self.present(alert, animated: true, completion: nil)
        }
    }}
