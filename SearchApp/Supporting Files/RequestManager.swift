//
//  RequestManager.swift
//  SearchApp
//
//  Created by Денис Андриевский on 22.07.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import Foundation

class RequestManager {
    
    private var dataTask: URLSessionDataTask?
    
    func requestForQuery(_ query: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlString = "http://195.201.56.43:8888/slow_search?q=\(query)"
        guard let url = URL(string: urlString) else { return }
        dataTask = URLSession(configuration: .default).dataTask(with: url, completionHandler: completionHandler)
        dataTask?.resume()
    }
    
    func cancelTask() {
        dataTask?.cancel()
    }
    
}
