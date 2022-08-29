//
//  BlogManager.swift
//  BlogApp-DelegateDesignPattern
//
//  Created by Samet Koyuncu on 28.08.2022.
//

import Foundation

protocol BlogManagerDelegate {
    func didSuccess(_ blogManager: BlogManager, blog: BlogData)
    func didError(_ error: Error)
}

struct BlogManager {
    let apiURL = "https://jsonplaceholder.typicode.com/posts/"
    
    var delegate: BlogManagerDelegate?
    
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
    }
}

