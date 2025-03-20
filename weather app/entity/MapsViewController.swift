//
//  MapsViewController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {

    let mapView = MKMapView()
       let menuButton = UIButton(type: .system)
       let titleLabel = UILabel()
       let noteLabel = UILabel()
       let zoomInButton = UIButton(type: .system)
       let zoomOutButton = UIButton(type: .system)
       let locationButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
              setupTitleLabel()
              setupMenuButton()
              setupMapView()
              setupZoomButtons()
             
              showNote() // Uyarı notunu gösterme
              mapView.delegate = self
    }

    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          adjustMapViewFrame()
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

    func setupTitleLabel() {
        titleLabel.text = "Haritalar"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Başlık etiketini üst merkezde yerleştirme
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupMenuButton() {
        let image = UIImage(systemName:"line.3.horizontal")
        menuButton.setImage(image, for: .normal)
        menuButton.tintColor = .white
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuButton)

        // Menü butonunu başlığın altına yerleştirme
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            menuButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            menuButton.widthAnchor.constraint(equalToConstant: 50),
            menuButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Menü butonuna dokunma olayını ekleme
        menuButton.addTarget(self, action: #selector(showMapOptions), for: .touchUpInside)
    }

    func setupMapView() {
            mapView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(mapView)
        }

    func adjustMapViewFrame() {
            // Harita görünümünün konumu ve boyutu
            NSLayoutConstraint.activate([
                mapView.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 10),
                mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    func setupZoomButtons() {
           zoomInButton.setTitle("+", for: .normal)
           zoomInButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
           zoomInButton.setTitleColor(.black, for: .normal)
        zoomInButton.backgroundColor = .clear
           zoomInButton.layer.cornerRadius = 8
           zoomInButton.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(zoomInButton)

           zoomOutButton.setTitle("-", for: .normal)
           zoomOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
           zoomOutButton.setTitleColor(.black, for: .normal)
        zoomOutButton.backgroundColor = .clear
           zoomOutButton.layer.cornerRadius = 8
           zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(zoomOutButton)

           // Zoom in butonunu sağ alt köşeye yerleştirme
           NSLayoutConstraint.activate([
               zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               zoomInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
               zoomInButton.widthAnchor.constraint(equalToConstant: 40),
               zoomInButton.heightAnchor.constraint(equalToConstant: 40)
           ])

           // Zoom out butonunu zoom in butonunun altına yerleştirme
           NSLayoutConstraint.activate([
               zoomOutButton.trailingAnchor.constraint(equalTo: zoomInButton.trailingAnchor),
               zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 10),
               zoomOutButton.widthAnchor.constraint(equalTo: zoomInButton.widthAnchor),
               zoomOutButton.heightAnchor.constraint(equalTo: zoomInButton.heightAnchor)
           ])

           zoomInButton.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
           zoomOutButton.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
       }
    
    @objc func zoomIn() {
        let region = mapView.region
        let newLatitudeDelta = max(region.span.latitudeDelta / 2, 0.001)
        let newLongitudeDelta = max(region.span.longitudeDelta / 2, 0.001)
        let span = MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLongitudeDelta)
        let newRegion = MKCoordinateRegion(center: region.center, span: span)
        mapView.setRegion(newRegion, animated: true)
    }

    @objc func zoomOut() {
        let region = mapView.region
        let newLatitudeDelta = min(region.span.latitudeDelta * 2, 90.0) // Ensure max value does not exceed practical limit
        let newLongitudeDelta = min(region.span.longitudeDelta * 2, 180.0) // Ensure max value does not exceed practical limit
        let span = MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLongitudeDelta)
        let newRegion = MKCoordinateRegion(center: region.center, span: span)
        mapView.setRegion(newRegion, animated: true)
    }


    

    func showNote() {
        noteLabel.text = "Üst tarafta yer alan menü çubuğundan harita katmanını seçebilirsiniz."
        noteLabel.textColor = .white
        noteLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        noteLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 0 // Metnin birden fazla satırda görünmesi için satır sayısını sınırsız yapıyoruz.
        noteLabel.layer.cornerRadius = 8
        noteLabel.layer.masksToBounds = true
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteLabel)

        // Uyarı notunu haritanın altına yerleştirme
        NSLayoutConstraint.activate([
            noteLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Sol kenardan 20 birim boşluk bırakma
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // Sağ kenardan 20 birim boşluk bırakma
        ])

        // 5 saniye sonra notu gizleme
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1.0, animations: {
                self.noteLabel.alpha = 0
            }, completion: { _ in
                self.noteLabel.removeFromSuperview()
            })
        }
    }

    @objc func showMapOptions() {
        let alertController = UIAlertController(title: "Harita Katmanı Seçiniz", message: nil, preferredStyle: .actionSheet)

        let windAction = UIAlertAction(title: "Rüzgar Haritası", style: .default) { _ in
            self.loadMapLayer(for: "wind_new")
        }
        let tempAction = UIAlertAction(title: "Sıcaklık Haritası", style: .default) { _ in
            self.loadMapLayer(for: "temp_new")
        }
        let cloudsAction = UIAlertAction(title: "Bulut Haritası", style: .default) { _ in
            self.loadMapLayer(for: "clouds_new")
        }
        let precipitationAction = UIAlertAction(title: "Yağış Haritası", style: .default) { _ in
            self.loadMapLayer(for: "precipitation_new")
        }
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        
        alertController.addAction(windAction)
        alertController.addAction(tempAction)
        alertController.addAction(cloudsAction)
        alertController.addAction(precipitationAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func loadMapLayer(for layer: String) {
        mapView.removeOverlays(mapView.overlays)
        let apiKey = "1082aea547f60691ff6e13114b25e759"
        let template = "https://tile.openweathermap.org/map/\(layer)/{z}/{x}/{y}.png?appid=\(apiKey)"
        let overlay = MKTileOverlay(urlTemplate: template)
        overlay.canReplaceMapContent = false
        mapView.addOverlay(overlay, level: .aboveLabels)
    }
}

// MKMapViewDelegate için uzantı
extension MapsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
