import XCTest
@testable import Hava_Durumu_Takip
import MessageUI

final class set1: XCTestCase {

    var viewController: SettingsViewController!
    var window: UIWindow!

    override func setUpWithError() throws {
        super.setUp()
        
        // Testi başlatmadan önce bir window oluştur
        window = UIWindow(frame: UIScreen.main.bounds)
        viewController = SettingsViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    override func tearDownWithError() throws {
        viewController = nil
        window = nil
        super.tearDown()
    }

    func testUIElementsArePresent() throws {
        // UI elementlerinin mevcut olduğunu kontrol et
        XCTAssertNotNil(viewController.titleLabel)
        XCTAssertNotNil(viewController.temperatureSegmentedControl)
        XCTAssertNotNil(viewController.windSegmentedControl)
        XCTAssertNotNil(viewController.privacyPolicyLabel)
        XCTAssertNotNil(viewController.contactLabel)
        XCTAssertNotNil(viewController.versionLabel)
        
        // TableView'lerin mevcut olduğunu kontrol et
        XCTAssertEqual(viewController.tableViews.count, 4)
    }

    func testInitialSegmentedControlStates() throws {
        // UserDefaults'dan değer alıp, segmentedControl'lerin doğru şekilde ayarlandığını kontrol et
        let temperatureUnit = UserDefaults.standard.integer(forKey: "temperatureUnit")
        let windUnit = UserDefaults.standard.integer(forKey: "windUnit")
        
        XCTAssertEqual(viewController.temperatureSegmentedControl.selectedSegmentIndex, temperatureUnit)
        XCTAssertEqual(viewController.windSegmentedControl.selectedSegmentIndex, windUnit)
    }

    func testTemperatureUnitChanged() throws {
        // SegmentedControl değiştirildiğinde UserDefaults'ın güncellendiğini kontrol et
        let newIndex = 1
        viewController.temperatureSegmentedControl.selectedSegmentIndex = newIndex
        viewController.temperatureUnitChanged()
        
        let storedIndex = UserDefaults.standard.integer(forKey: "temperatureUnit")
        XCTAssertEqual(storedIndex, newIndex)
    }

    func testWindUnitChanged() throws {
        // SegmentedControl değiştirildiğinde UserDefaults'ın güncellendiğini kontrol et
        let newIndex = 0
        viewController.windSegmentedControl.selectedSegmentIndex = newIndex
        viewController.windUnitChanged()
        
        let storedIndex = UserDefaults.standard.integer(forKey: "windUnit")
        XCTAssertEqual(storedIndex, newIndex)
    }

    func testPrivacyTapped() throws {
        // Gizlilik politikası hücresine tıklanıldığında PrivacyPolicyViewController'ın açıldığını kontrol et
        viewController.privacyTapped()
        
        let presentedVC = viewController.presentedViewController as? PrivacyPolicyViewController
        XCTAssertNotNil(presentedVC)
    }

    func testEmailComposeController() throws {
        // MFMailComposeViewController'ın düzgün şekilde oluşturulduğunu ve gösterildiğini test et
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = viewController
            
            viewController.present(mailComposeVC, animated: true, completion: nil)
            
            XCTAssertTrue(viewController.presentedViewController is MFMailComposeViewController)
        } else {
            let alert = UIAlertController(title: "E-posta Gönderilemedi", message: "E-posta gönderebilmek için bir e-posta hesabı yapılandırmalısınız.", preferredStyle: .alert)
            viewController.present(alert, animated: true, completion: nil)
            
            XCTAssertTrue(viewController.presentedViewController is UIAlertController)
        }
    }
}
