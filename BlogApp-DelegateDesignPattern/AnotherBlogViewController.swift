//
//  AnotherBlogViewController.swift
//  BlogApp-DelegateDesignPattern
//
//  Created by Samet Koyuncu on 28.08.2022.
//

import UIKit

class AnotherBlogViewController: UIViewController {
    
    var blogManager = BlogManager()
    
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var postBodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        blogManager.delegate = self
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let text = idField.text else { return }
        
        if let id = Int(text) {
            blogManager.fetchBlog(withId: id)
        }
    }
    
}

extension AnotherBlogViewController: BlogManagerDelegate {
    func didSuccess(_ blogManager: BlogManager, blog: BlogData) {
        DispatchQueue.main.async {
            self.postBodyLabel.text = blog.body
        }
    }
    
    func didError(_ error: Error) {
        DispatchQueue.main.async {
            self.postBodyLabel.text = "Bir hata oluştu."
        }
    }
}
