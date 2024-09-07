import Foundation
import UIKit

class PrivacyPolicyViewController: UIViewController {

    private let privacyPolicyTextView: UITextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.isEditable = false
            textView.isScrollEnabled = true
            textView.backgroundColor = .clear
            textView.textColor = .white
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.text = """
            Gizlilik Politikası

            Son Güncelleme Tarihi: 18.08.2024

            Bu Gizlilik Politikası, MayApp Initiative  olarak, kişisel verilerinizi nasıl topladığımızı, kullandığımızı ve koruduğumuzu açıklar. Uygulamamızı kullanarak bu politikayı kabul etmiş olursunuz.

            1. Topladığımız Bilgiler

            Uygulamamız, aşağıdaki türde bilgiler toplayabilir:

            - Kişisel Bilgiler: Uygulamayı kullanırken kişisel bilgilerinizi (örneğin, e-posta adresi, ad ve soyad) bizlerle paylaşabilirsiniz. Bu bilgileri, uygulama içi iletişim ve destek amaçlarıyla kullanabiliriz.
            - Konum Bilgileri: Hava durumu tahminleri sağlamak için konum bilgilerinizi toplayabiliriz. Bu bilgiler, hava durumu verilerini size en doğru şekilde sunabilmemiz için kullanılır.
            
            

            2. Bilgilerin Kullanımı

            Topladığımız bilgileri aşağıdaki amaçlarla kullanabiliriz:

            - Hizmet Sağlama: Uygulamamızın işlevlerini sağlamak, hava durumu tahminleri sunmak ve kişisel ayarlarınızı hatırlamak için.
            
            - İletişim: Size uygulama güncellemeleri, yeni özellikler hakkında bilgi vermek veya size destek sağlamak amacıyla.
            
            - Geliştirme ve İyileştirme: Uygulamamızın performansını ve kullanıcı deneyimini iyileştirmek amacıyla.

            3. Bilgilerin Paylaşımı

            Kişisel bilgilerinizi üçüncü şahıslarla paylaşmayız, ancak aşağıdaki durumlarda paylaşabiliriz:

            - Yasal Gereklilikler: Yasal süreçlere uyum sağlamak, yasal haklarımızı korumak veya devlet kurumları veya yetkili organlarla bilgi paylaşımında bulunmak gerekebilir.
            
            
            
            Bu Gizlilik Politikası, MayApp Initiative adlı şirketimiz tarafından sağlanan hizmetler için geçerlidir.
            """
            return textView
        }()

    private let privacyPolicyTextTitle: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false // Başlık için scroll yapmayı devre dışı bırakıyoruz
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 24, weight: .bold)
        textView.text = "Gizlilik Politikası"
        textView.textAlignment = .center
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 37/255, green: 50/255, blue: 89/255, alpha: 1.0)
        setupViews()
        
             
    }
  
    
    private func setupViews() {
        view.addSubview(privacyPolicyTextTitle)
        view.addSubview(privacyPolicyTextView)
        
        NSLayoutConstraint.activate([
            // Başlık
            privacyPolicyTextTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            privacyPolicyTextTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            privacyPolicyTextTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            privacyPolicyTextTitle.heightAnchor.constraint(equalToConstant: 40),
            
            // Metin
            privacyPolicyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            privacyPolicyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            privacyPolicyTextView.topAnchor.constraint(equalTo: privacyPolicyTextTitle.bottomAnchor, constant: 16),
            privacyPolicyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
