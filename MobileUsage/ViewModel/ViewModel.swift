//
//  ViewModel.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 6/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import Foundation

class ViewModel {
    internal var dataProxy: DataProxy?
    private var listMobileUsage:[yearlyRecord] = [yearlyRecord]()
    internal let session: URLSession

    init() {
        self.session = URLSession()
        self.dataProxy = DataProxy(session: session)
    }
    
    // this for purpose of mockup 
    init(session:URLSession){
        self.session = session
        self.dataProxy = DataProxy(session: self.session)
    }
    
    func fetchData(completion:@escaping (_ numberOfRecord:Int?,_ err: FechError? ) -> Void) {
        self.dataProxy?.fetchData({ (data, error) in
            if error != nil || data == nil {
                completion(0, error)
                return
            }
            
            let jsonResult = util.decode(data)
            if let result = jsonResult {
                let yearly = util.getYearlyArray(result)
                self.listMobileUsage.append(contentsOf: yearly)
                completion(yearly.count, nil)
            }
        })
    }
    
    func getItemAt(_ indx:Int) -> yearlyRecord?
    {
        if indx < listMobileUsage.count && indx >= 0 {
            return listMobileUsage[indx]
        }
        return nil
    }
}
