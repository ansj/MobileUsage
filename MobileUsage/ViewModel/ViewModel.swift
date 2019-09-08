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
    private var url:URL?
    private var nextUrl:URL?
    private let startURL = URL(string: "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=10")!
    

    init() {
        self.session = URLSession.shared
        self.dataProxy = DataProxy(session: session)
    }
    
    // this for purpose of mockup 
    init(session:URLSession){
        self.session = session
        self.dataProxy = DataProxy(session: self.session)
    }
    
    func fetchData(_ bInitial: Bool=true, completion:@escaping (_ numberOfRecord:Int?,_ err: FechError? ) -> Void) {
        
        if !Reachability.isConnectedToNetwork()  {
            if self.listMobileUsage.count > 0 {
                return
            }
            getData()
            if self.listMobileUsage.count == 0 {
                completion(self.listMobileUsage.count, FechError.error)
                return
            }
            completion(self.listMobileUsage.count, nil)
            return
        }
        
        if bInitial {
            self.url = startURL
        }
        else {
            if self.nextUrl == nil {
                completion(0, FechError.noNextURL)
                return
            }
            self.url = self.nextUrl
        }
        
        self.dataProxy?.fetchData( self.url!,  completion: { (data, error) in
            if error != nil || data == nil {
                completion(0, error)
                return
            }
            
            let jsonResult = util.decode(data)
            if let result = jsonResult {
                let yearly = util.getYearlyArray(result)
                self.listMobileUsage.append(contentsOf: yearly)
                
                if let url = util.getNextUrl(result) {
                    self.nextUrl = url
                }
                else {
                    self.nextUrl = nil
                }
                
                //print(self.listMobileUsage)
                self.listMobileUsage = util.getGroupYearlyArray(self.listMobileUsage)
                
                completion(self.listMobileUsage.count, nil)
            }
            else {
                self.saveData()
                completion(0, FechError.noData)
            }
        })
    }
    
    func getItemAt(_ indx:Int) -> (data:yearlyRecord?, haveDecrease:Bool)
    {
        if indx < listMobileUsage.count && indx >= 0 {
            let data = listMobileUsage[indx]
            let haveDecrease = util.containDecreaseQData(data.volume_of_mobile_data)
            return (data, haveDecrease)
        }
        return (nil, false)
    }
    
    private func saveData() {
        if self.listMobileUsage.count > 0 {
            Persist.saveList(self.listMobileUsage)
        }
    }
    
    private func getData() {
        let savedData = Persist.getList()
        if let theList = savedData {
            self.listMobileUsage = theList
        }
    }
}
