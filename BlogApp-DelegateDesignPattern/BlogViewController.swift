//
//  ViewController.swift
//  BlogApp-DelegateDesignPattern
//
//  Created by Samet Koyuncu on 28.08.2022.
//

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


