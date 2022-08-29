---

Swift'te 'The Delegate Design Pattern' Nedir? Nasıl Kullanılır? 
Merhaba, arkadaşlar. Yaklaşık bir buçuk ay önce yazılımda web alanından mobil iOS alanına geçmeye karar verdim. Bu süreçte oldukça hoşuma giden bir konuyu sizlerle paylaşmak istiyorum. Umarım faydalı sizler için faydalı olur.
Bu yazımda sizlere  'Delegate Desing Pattern' nedir ve nasıl kullanılır onu anlatacağım. İlk olarak neden ihtiyacımız olduğunu ve bu ihtiyacımıza nasıl çözüm sunduğunu teorik olarak anlamaya çalışıp, ardından basit bir uygulama geliştireceğiz.
Problem?
Şimdi api üzerinde veri çeken BlogManager adında bir struct yapımız olsun. Bir de BlogViewController adında, BlogManager'ın api'den gelen veriyi kullanıcıya gösterecek UIViewController sınıfımız olsun. Normalde aşağıdaki görselde olduğu gibi BlogManager'da BlogViewController'ın bir instance'ını oluşturur ve bu instance üzerinden işlemler sonucunda çeşitli methodları tetiklerdik.
Peki,  AnotherViewController adında bir başka sınıfımız olsa ve bu sınıf da BlogManager'dan gelen veri ile işlem yapıyor olsa nasıl olurdu.
Bu sefer AnotherViewController'ın bir instance'ını oluşturup, onun üzerinden gerekli tetiklemeleri yapmamız gerekecekti. Yukarıdaki görselde gördüğünüz üzere şimdiden kodlarımız karışmaya başladı ve her yapacağımız işlem için BlogManager'a müdahale etmek durumunda kaldık. Delegate Design Pattern de tam olarak burada olaya dahil oluyor. Peki bu nasıl oluyor, gelin beraber bakalım.
Çözüm
İlk olarak manager ve view controller yapılarımızı ortak paydada buluşturacak, BlogManagerDelegate adında bir protokol oluşturuyoruz.
Manager yapısına ve view controller sınıflarına bu protokolü ekliyoruz. (Kırmızı ile işaretli yerler.)
 BlogManager içerisinde BlogManagerDelegate tipinde, delegate adında optional bir değişken ekliyoruz. (Mor ile işaretli yer.)
View controller sınıflarında BlogManager'dan bir instance oluşturup, manager'daki delegate değişkenine 'self' ile view controller sınıflarımızın kendisini atıyoruz. 🤯   (Sarı ile işaretli yerler.)
Son olarak BlogManager içerisinden tetiklenecek methodları 'delegate?.methodName()' şeklinde değiştiriyoruz. (Yeşil ile işaretli yerler.)

Ve işlem tamam, artık ne kadar sınıf BlogManager'dan veri çekmeye çalışırsa çalışsın, BlogManager.swift dosyası üzerinde herhangi bir değişiklik yapmamıza gerek kalmayacak. Sadece kullanmak istediğimiz yerde gerekli düzenlemeleri yapmak yeterli olacak. 
İşte bu yaklaşımın adı Delegate Design Pattern. Şimdi daha da iyi kavrayabilmek için basit bir uygulama üzerinde konuyu görelim.

---

BlogApp Uygulaması
Tanıtım
Uygulamamız iki adet ekrandan oluşuyor. İki ekranda da birer adet textField ve button bulunmakta. Kullanıcının girmiş olduğu id numarasına göre api'dan veri çekilecek ve ilk view controller'da veriler alert olarak gösterilecek. İkinci view controller'da ise içerik ekrandaki label'a yazdırılacak.
Veriler https://jsonplaceholder.typicode.com/posts/{id} adresine istek atarak çekilecek ve gelen veri aşağıdaki gibi bir JSON objesi olacak.
Proje
İlk olarak aşağıdaki gibi bir Xcode projesi oluşturalım.

2. BlogViewController ve AnotherViewController adında iki adet Cocoa Touch Class dosyası oluşturalım. Ardından view tasarımlarını yukarıdaki gibi ayarlayalım.
3. Oluşturduğumuz sınıflara, tasarımdaki ilgili nesneleri bağlayalım.

4. Api ile iletişim kurmak için kullanacağımız BlogManager.swift ve gelen veriyi decode edeceğimiz BlogData.swift dosyalarını oluşturalım.
 BlogManager içerisindeki performRequest bir URLSesion işlemi, parseJSON ise api'den gelen JSON verinin BlogData'ya çevrilme işlemidir. Konu ile alakasız oldukları için detaylarına girmeyeceğim.
5. Projenin temel yapısını oluşturduk. Şimdi de Delegate Design Pattern'i uygulayalım. BlogManager.swift dosyamıza BlogManagerDelegate adında bir protokol ekiyoruz. Bu protokol iki adet fonksiyon taslağı barındıracak, didSuccess ve didError. Api'ye yapılan istek sonrası, cevap başarılı döndüyse didSuccess tetiklenecek, bir sorun meydana geldiyse didError tetiklenecek.
6. Sonrasında, yine aynı dosyada delegate değişkenimizi oluşturalım.
7. BlogManager'daki gerekli method tetiklemelerini gerçekleştirelim. 
8. BlogViewContoller üzerinde gerekli değişiklikleri yaparak, ekrana alert ile post.id ve post.title değerlerini yazdıralım. Hata durumunda ise yine alert ile kullanıcıyı bilgilendirelim. 
9. AnotherBlogViewController'ı da pratik olması için size bırakıyorum. Yapmanız gereken tek farklı şey verileri alert yerine postBodyLabel'da göstermek. (Sadece post'un body kısmı gösterilecek. Dilerseniz tasarımı istediğiniz gibi değiştirip, ına göre işlem yapabilirsiniz.)
10. Uygulamanın son haline aşağıdaki videodan bakabilirsiniz.

11. Proje dosyalarına ve bu yazının daha güzel haline (kodlar görsel değil, kopyalanabilir. :)) aşağıdaki GitHub repo'sundan erişebilirsiniz.
GitHub - sametkoyuncu/BlogApp-DelegateDesignPattern
You can't perform that action at this time. You signed in with another tab or window. You signed out in another tab or…github.com
Son Söz
Buraya kadar geldiğiniz için teşekkürler. Bu benim medium üzerinde ilk yazım oldu. Dediğim gibi iOS tarafında da yeniyim. Elbetteki eksiklerim, hatalarım olmuştur. Sizden ricam bunları bana iletebilirseniz hem benim gelişimime hem de yazıyı okuyacak olan kişilerin daha doğru bilgi edinmesine katkı sağlamış olursunuz. Tekrar teşekkürler, hepinize iyi çalışmalar.. ❤️
Bana Ulaşın
LinkedIn: https://www.linkedin.com/in/samet-koyuncu/
Email: sametkoyuncu@live.com
Twitter: https://twitter.com/sametdotpage
Website: https://samet.page/
