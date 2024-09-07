//
//  SettingsViewController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    var tableViews: [UITableView] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ayarlar"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    let temperatureSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["°C", "°F"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "temperatureUnit")
        segmentedControl.selectedSegmentTintColor = .red
        segmentedControl.addTarget(self, action: #selector(temperatureUnitChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    let temperatureUnitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sıcaklık Birimi"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let windUnitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hız Birimi"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let windSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["m/s", "mph"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "windUnit")
        segmentedControl.selectedSegmentTintColor = .red
        segmentedControl.addTarget(self, action: #selector(windUnitChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    let privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Gizlilik Politikası"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let contactLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "İletişim"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "version 1.0"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupTitleLabel()
        setupTableViews()
        setupVersionLabel()
        
        for tableView in tableViews {
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("SettingsChanged"), object: nil)
    }
    
    @objc func temperatureUnitChanged() {
        UserDefaults.standard.set(temperatureSegmentedControl.selectedSegmentIndex, forKey: "temperatureUnit")
    }
    
    @objc func windUnitChanged() {
        UserDefaults.standard.set(windSegmentedControl.selectedSegmentIndex, forKey: "windUnit")
    }
    // Background Color
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
    
    func setupTitleLabel() {
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    func setupTableViews() {
        let numberOfTableViews = 4 // Sıcaklık, Hız, Gizlilik, İletişim
        
        for i in 0..<numberOfTableViews {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.backgroundColor = .clear // Şeffaf arka plan
            tableView.layer.borderColor = UIColor.clear.cgColor
            tableView.layer.borderWidth = 1.0
            tableView.layer.cornerRadius = 10
            tableView.layer.masksToBounds = true
            tableView.tag = i + 1
            tableView.dataSource = self
            tableView.delegate = self
            self.view.addSubview(tableView)
            tableViews.append(tableView)
        }
        
        setupTableViewConstraints()
    }
    
    func setupTableViewConstraints() {
        let tableViewHeight: CGFloat = 60
        let spacing: CGFloat = 20
        
        for (index, tableView) in tableViews.enumerated() {
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                tableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
            ])
            
            if index == 0 {
                tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing).isActive = true
            } else {
                tableView.topAnchor.constraint(equalTo: tableViews[index - 1].bottomAnchor, constant: spacing).isActive = true
            }
        }
    }
    
    func setupVersionLabel() {
        self.view.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            versionLabel.widthAnchor.constraint(equalToConstant: 100) // Adjust as needed
        ])
    }
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        // Eski içeriğin silinip yeni içeriğin geçmesini sağlar collection view'a
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
    
        cell.backgroundColor = .clear
        
        // Hücre seçildiğinde gri renk kalmaması için
        cell.selectionStyle = .none
        
        // İkon için bir UIImageView
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white // İkon rengini beyaz yap
        cell.contentView.addSubview(iconImageView)
        
        // Hücre içeriğini ayarı
        switch tableView.tag {
        case 1:
            iconImageView.image = UIImage(systemName: "thermometer")
            cell.contentView.addSubview(temperatureUnitLabel)
            cell.contentView.addSubview(temperatureSegmentedControl)
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                iconImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 20),
                iconImageView.heightAnchor.constraint(equalToConstant: 20),
                temperatureUnitLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                temperatureUnitLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                temperatureSegmentedControl.leadingAnchor.constraint(equalTo: temperatureUnitLabel.trailingAnchor, constant: 10),
                temperatureSegmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                temperatureSegmentedControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        case 2:
            iconImageView.image = UIImage(systemName: "wind")
            cell.contentView.addSubview(windUnitLabel)
            cell.contentView.addSubview(windSegmentedControl)
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                iconImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 20),
                iconImageView.heightAnchor.constraint(equalToConstant: 20),
                windUnitLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                windUnitLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                windSegmentedControl.leadingAnchor.constraint(equalTo: windUnitLabel.trailingAnchor, constant: 10),
                windSegmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                windSegmentedControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        case 3:
            iconImageView.image = UIImage(systemName: "lock.shield")
            cell.contentView.addSubview(privacyPolicyLabel)
            
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                iconImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 20),
                iconImageView.heightAnchor.constraint(equalToConstant: 20),
                privacyPolicyLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                privacyPolicyLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                privacyPolicyLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10)
            ])
        case 4:
            iconImageView.image = UIImage(systemName: "envelope")
            cell.contentView.addSubview(contactLabel)
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                iconImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 20),
                iconImageView.heightAnchor.constraint(equalToConstant: 20),
                contactLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                contactLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                contactLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10)
            ])
        default:
            break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 3: // Gizlilik Politikası
            privacyTapped()
        case 4: // İletişim
            if MFMailComposeViewController.canSendMail() {
                let mailComposeVC = MFMailComposeViewController()
                mailComposeVC.mailComposeDelegate = self
                mailComposeVC.setToRecipients(["yakup7312@hotmail.com"])
                mailComposeVC.setSubject("Destek Talebi")
                mailComposeVC.setMessageBody("Merhaba, destek talebim var.", isHTML: false)
                self.present(mailComposeVC, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "E-posta Gönderilemedi", message: "E-posta gönderebilmek için bir e-posta hesabı yapılandırmalısınız.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
        
        // Hücrenin seçimini kaldır
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MFMailComposeViewControllerDelegate Methods
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    // Acces to Privacy Page
    func privacyTapped(){
        let privacyVC = PrivacyPolicyViewController()
        privacyVC.modalPresentationStyle = .pageSheet
        self.present(privacyVC, animated: true, completion: nil)
    }
}
