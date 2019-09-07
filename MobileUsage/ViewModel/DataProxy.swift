//
//  DataProxy.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 6/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import Foundation

enum FechError: Error {
    case error
    case responseError
    case wrongMimeType
    case noNextURL
}

class DataProxy {
    private let session: URLSession
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func fetchData(_ url:URL = URL(string:"url")!, completion:@escaping (_ data:Data?, _ error: FechError?) ->Void ) {
        
        let task = self.session.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                completion(nil, FechError.error)
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                
                completion(nil, FechError.responseError)
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                completion(nil, FechError.wrongMimeType)
                return
            }
            
            completion(data, nil)
        }
        
        task.resume()
    }
}
