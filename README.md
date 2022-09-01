> Bu repository'de "Swift'te 'Delegate Design Pattern' Nedir? Nasıl Kullanılır?" isimli blog yazım ve örnek uygulaması bulunmaktadır. İyi keyifler.. :)

# Swift'te 'Delegate Design Pattern' Nedir? Nasıl Kullanılır? 
Merhaba, arkadaşlar. Yaklaşık bir buçuk ay önce yazılımda web alanından mobil iOS alanına geçmeye karar verdim. Bu süreçte oldukça hoşuma giden bir konuyu sizlerle paylaşmak istiyorum. Umarım sizler için faydalı olur.

Bu yazımda sizlere  'Delegate Desing Pattern' nedir ve nasıl kullanılır onu anlatacağım. İlk olarak neden ihtiyacımız olduğunu ve bu ihtiyacımıza nasıl çözüm sunduğunu teorik olarak anlamaya çalışıp, ardından basit bir uygulama geliştireceğiz.

## Problem?
Şimdi api üzerinde veri çeken BlogManager adında bir struct yapımız olsun. Bir de BlogViewController adında, BlogManager'ın api'den gelen veriyi kullanıcıya gösterecek UIViewController sınıfımız olsun. Normalde aşağıdaki görselde olduğu gibi BlogManager'da BlogViewController'ın bir instance'ını oluşturur ve bu instance üzerinden işlemler sonucunda çeşitli methodları tetiklerdik.

![1](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern/blob/main/images/1.png?raw=true)

Peki,  AnotherViewController adında bir başka sınıfımız olsa ve bu sınıf da BlogManager'dan gelen veri ile işlem yapıyor olsa nasıl olurdu.

![2](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern/blob/main/images/2.png?raw=true)

Bu sefer AnotherViewController'ın bir instance'ını oluşturup, onun üzerinden gerekli tetiklemeleri yapmamız gerekecekti. Yukarıdaki görselde gördüğünüz üzere şimdiden kodlarımız karışmaya başladı ve her yapacağımız işlem için BlogManager'a müdahale etmek durumunda kaldık. Delegate Design Pattern de tam olarak burada olaya dahil oluyor. Peki bu nasıl oluyor, gelin beraber bakalım.

## Çözüm
* İlk olarak manager ve view controller yapılarımızı ortak paydada buluşturacak, BlogManagerDelegate adında bir protokol oluşturuyoruz.

![3](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern/blob/main/images/3.png?raw=true)

* Manager yapısına ve view controller sınıflarına bu protokolü ekliyoruz. (Kırmızı ile işaretli yerler.)
* BlogManager içerisinde BlogManagerDelegate tipinde, delegate adında optional bir değişken ekliyoruz. (Mor ile işaretli yer.)
* View controller sınıflarında BlogManager'dan bir instance oluşturup, manager'daki delegate değişkenine 'self' ile view controller sınıflarımızın kendisini atıyoruz. 🤯   (Sarı ile işaretli yerler.)
* Son olarak BlogManager içerisinden tetiklenecek methodları 'delegate?.methodName()' şeklinde değiştiriyoruz. (Yeşil ile işaretli yerler.)

![4](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern/blob/main/images/4.png?raw=true)

Ve işlem tamam, artık ne kadar sınıf BlogManager'dan veri çekmeye çalışırsa çalışsın, BlogManager.swift dosyası üzerinde herhangi bir değişiklik yapmamıza gerek kalmayacak. Sadece kullanmak istediğimiz yerde gerekli düzenlemeleri yapmak yeterli olacak. 

İşte bu yaklaşımın adı Delegate Design Pattern. Şimdi daha da iyi kavrayabilmek için basit bir uygulama üzerinde konuyu görelim.

---

## BlogApp Uygulaması
### Tanıtım
Uygulamamız iki adet ekrandan oluşuyor. İki ekranda da birer adet textField ve button bulunmakta. Kullanıcının girmiş olduğu id numarasına göre api'dan veri çekilecek. İlk view controller'da veriler alert olarak gösterilecek. İkinci view controller'da ise içerik ekrandaki label'a yazdırılacak.

![5](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern/blob/main/images/5.png?raw=true)

Veriler https://jsonplaceholder.typicode.com/posts/{id} adresine istek atarak çekilecek ve gelen veri aşağıdaki gibi bir JSON objesi olacak.

![6](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern/blob/main/images/6.png?raw=true)

### Proje
* İlk olarak aşağıdaki gibi bir Xcode projesi oluşturalım.

![7](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern/blob/main/images/7.png?raw=true)

* BlogViewController ve AnotherViewController adında iki adet Cocoa Touch Class dosyası oluşturalım. Ardından view tasarımlarını yukarıdaki gibi ayarlayalım.

![8](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern/blob/main/images/8.png?raw=true)

* Oluşturduğumuz sınıflara, tasarımdaki ilgili nesneleri bağlayalım.

```swift
import UIKit
class BlogViewController: UIViewController {
    @IBOutlet weak var idField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTapped(_ sender: UIButton) { }
}
```

```swift
import UIKit
class AnotherBlogViewController: UIViewController {
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var postBodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTapped(_ sender: UIButton) { }
}
```

* Api ile iletişim kurmak için kullanacağımız BlogManager.swift ve gelen veriyi decode edeceğimiz BlogData.swift dosyalarını oluşturalım.
> BlogManager içerisindeki performRequest bir URLSesion işlemi, parseJSON ise api'den gelen JSON verinin BlogData'ya çevrilme işlemidir. Konu ile alakasız oldukları için detaylarına girmeyeceğim.

```swift
// BlogManager.swift
import Foundation

struct BlogManager {
    let apiURL = "https://jsonplaceholder.typicode.com/posts/"
    
    func fetchBlog(withId blogId: Int) {
        performRequest(with: "\(apiURL)\(blogId)")
    }
    
    // MARK: - performRequest with url string
    func performRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give URLSession a task
            let task =  session.dataTask(with: url) { data, response, error in
                if error != nil {
                    // MARK: - HATA
                    print(error)
                    return
                }
                
                guard let safeData = data else { return }
                
                guard let blogPost = self.parseJSON(safeData) else { return }
                // MARK: - İŞLEM BAŞARILI
                print(blogPost)
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    // MARK: - Parsing data JSON to WeatherData
    func parseJSON(_ blogData: Data) -> BlogData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData: BlogData = try decoder.decode(BlogData.self, from: blogData)
            return decodedData
        } catch {
            // MARK: - HATA
            print(error)
            return nil
        }
    }
}
```

```swift
// BlogData.swift
struct BlogData: Codable {
    var id: Int
    var title: String
    var body: String
}
```
 
* Projenin temel yapısını oluşturduk. Şimdi de Delegate Design Pattern'i uygulayalım. BlogManager.swift dosyamıza BlogManagerDelegate adında bir protokol ekiyoruz. Bu protokol iki adet fonksiyon taslağı barındıracak, didSuccess ve didError. Api'ye yapılan istek sonrası, cevap başarılı döndüyse didSuccess tetiklenecek, bir sorun meydana geldiyse didError tetiklenecek.

```swift
// BlogManager.swift
protocol BlogManagerDelegate {
    func didSuccess(_ blogManager: BlogManager, blog: BlogData)
    func didError(_ error: Error)
}
```

* Sonrasında, yine aynı dosyada delegate değişkenimizi oluşturalım. (yorum satırları içerisinde delegate 1, delegate 2 ve delegate 3 yazan kısımlar)

```swift
// BlogManager.swift
struct BlogManager {
    let apiURL = "https://jsonplaceholder.typicode.com/posts/"
    
    var delegate: BlogManagerDelegate?
```

* BlogManager'daki gerekli method tetiklemelerini gerçekleştirelim. 
```swift
// BlogManager.swift
 // 3. Give URLSession a task
            let task =  session.dataTask(with: url) { data, response, error in
                if error != nil {
                    // MARK: - delegate 1
                    self.delegate?.didError(error!)
                    return
                }
                
                guard let safeData = data else { return }
                
                guard let blogPost = self.parseJSON(safeData) else { return }
                // MARK: - delegate 2
                delegate?.didSuccess(self,  blog: blogPost)
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    // MARK: - Parsing data JSON to WeatherData
    func parseJSON(_ blogData: Data) -> BlogData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData: BlogData = try decoder.decode(BlogData.self, from: blogData)
            return decodedData
        } catch {
            // MARK: - delegate 3
            delegate?.didError(error)
            return nil
        }
```
* BlogViewContoller üzerinde gerekli değişiklikleri yaparak, ekrana alert ile post.id ve post.title değerlerini yazdıralım. Hata durumunda ise yine alert ile kullanıcıyı bilgilendirelim. 

```swift
// BlogViewController
import UIKit

class BlogViewController: UIViewController {
    // blog manager'dan bir instance oluşturalım
    var blogManager = BlogManager()
    
    @IBOutlet weak var idField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegate değişkenine bulunduğumuz sınıfı atayalım
        // çünkü buradaki ilgili metodların tetiklenmesini istiyoruz
        blogManager.delegate = self
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let text = idField.text else { return }
        
        if let id = Int(text) {
            // blog id'ye göre api sorgusu için gerekli işlem
            blogManager.fetchBlog(withId: id)
        }
    }
}
// extension ile protokolü sınıfımıza ekliyoruz
extension BlogViewController: BlogManagerDelegate {
    // istek başarılı olursa çalışacak
    func didSuccess(_ blogManager: BlogManager, blog: BlogData) {
        DispatchQueue.main.async {
            self.idField.text = ""
            self.makeAlert(titleInput: "Success", messageInput: "Post Id: \(blog.id)\nPost Title: \(blog.title)")
        }
    }
    // hata alınırsa çalışacak
    func didError(_ error: Error) {
        DispatchQueue.main.async {
            self.idField.text = ""
            self.makeAlert(titleInput: "Error", messageInput: "Girilen id'ye ait kayıt bulunamadı. Lütfen tekrar deneyiniz.")
        }
    }
    // aynı kodları tekrar etmemek için, alert kodlarını ayırdık
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

```

* AnotherBlogViewController'ı da pratik olması için size bırakıyorum. Yapmanız gereken tek farklı şey verileri alert yerine postBodyLabel'da göstermek. (Sadece post'un body kısmı gösterilecek. Dilerseniz tasarımı istediğiniz gibi değiştirip, ına göre işlem yapabilirsiniz.)
* Uygulamanın son haline aşağıdaki videodan bakabilirsiniz.
[BlogApp-DelegateDesignPattern Youtube](https://youtube.com/shorts/qLU306V1_Ik?feature=share)

* Proje dosyalarına ve bu yazının daha güzel haline (kodlar görsel değil, kopyalanabilir. :)) aşağıdaki GitHub repo'sundan erişebilirsiniz.
[BlogApp-DelegateDesignPattern GitHub](https://github.com/sametkoyuncu/BlogApp-DelegateDesignPattern)

## Son Söz
Buraya kadar geldiğiniz için teşekkürler. Bu benim medium üzerinde ilk yazım oldu. Dediğim gibi iOS tarafında da yeniyim. Elbetteki eksiklerim, hatalarım olmuştur. Sizden ricam bunları bana iletebilirseniz hem benim gelişimime hem de yazıyı okuyacak olan kişilerin daha doğru bilgi edinmesine katkı sağlamış olursunuz. Tekrar teşekkürler, hepinize iyi çalışmalar.. ❤️

## Bana Ulaşın
* [LinkedIn](https://www.linkedin.com/in/samet-koyuncu/)
* [Twitter](https://twitter.com/sametdotpage)
* [Website](https://samet.page/)
* [Email](mailto:sametkoyuncu@live.com)

## Kaynaklar
* [Angela Yu - Udemy iOS Course](https://www.udemy.com/course/ios-13-app-development-bootcamp/)
* [Rebeloper Youtube Channel](https://youtu.be/UQnSdXFDAQQ)
