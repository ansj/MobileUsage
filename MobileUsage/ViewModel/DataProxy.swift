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
}

class DataProxy {
    private let session: URLSession
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func fetchData(_ completion:@escaping (_ data:Data?, _ error: FechError?) ->Void ) {
        let url = URL(string: "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=3")!
        
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
