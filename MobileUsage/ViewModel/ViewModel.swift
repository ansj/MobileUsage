//
//  ViewModel.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 6/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import Foundation

class ViewModel {
    private let dataProxy: DataProxy?
    
    init() {
        let session = URLSession()
        self.dataProxy = DataProxy(session: session)
    }
    
    func fetchData(completion:@escaping (_ numberOfRecord:Int?,_ err: FechError? ) -> Void) {
        self.dataProxy?.fetchData({ (data, error) in
            if error != nil || data == nil {
                completion(0, error)
                return
            }
            
            let jsonResult = util.decode(data)
            
        })
    }
}
