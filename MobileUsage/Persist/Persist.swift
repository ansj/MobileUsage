//
//  Persist.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 8/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import Foundation

class Persist {
    class func saveList(_ list:[yearlyRecord]) {
        var itemToSave = [MobileDataPersistModel]()
        for rec in list {
            let item = MobileDataPersistModel(year: rec.year, volume_of_mobile_data: rec.volume_of_mobile_data, total_volume: rec.total_volume)
            itemToSave.append(item)
        }
        let def = UserDefaults.standard
        def.set(NSKeyedArchiver.archivedData(withRootObject: itemToSave), forKey: "saved_key")
        def.synchronize()
    }
    
    class func getList() -> [yearlyRecord]? {
        let data = UserDefaults.standard.object(forKey: "saved_key")
        if data != nil {
            if let decodedList = NSKeyedUnarchiver.unarchiveObject(with: data as! Data ) as? [MobileDataPersistModel] {
                var yearlyRecords = [yearlyRecord]()
                for item in decodedList {
                    let rec = yearlyRecord(year: item.year, volume_of_mobile_data: item.volume_of_mobile_data, total_volume: item.total_volume)
                    yearlyRecords.append(rec)
                }
                return yearlyRecords
            }
        }
        return nil
    }
}
