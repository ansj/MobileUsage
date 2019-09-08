//
//  File.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 8/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import Foundation

class MobileDataPersistModel : NSObject, NSCoding {
    
    var year: String
    var volume_of_mobile_data: String
    var total_volume: Double
    
    init(year: String, volume_of_mobile_data: String,total_volume:Double ) {
        self.year = year
        self.volume_of_mobile_data = volume_of_mobile_data
        self.total_volume = total_volume
    }
    
    required init(coder aDecoder: NSCoder) {
        total_volume = aDecoder.decodeDouble(forKey: "total_volume")
        year = aDecoder.decodeObject(forKey: "year") as! String
        volume_of_mobile_data = aDecoder.decodeObject(forKey: "volume_of_mobile_data") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(year, forKey: "year")
        aCoder.encode(Double(total_volume), forKey: "total_volume")
        aCoder.encode(volume_of_mobile_data, forKey: "volume_of_mobile_data")
    }
}
