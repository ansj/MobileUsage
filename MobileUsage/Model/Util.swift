//
//  Util.swift
//  MobileUsage
//
//  Created by Ananta Sjartuni on 5/9/19.
//  Copyright © 2019 Ananta Sjartuni. All rights reserved.
//

import Foundation

class util{
    class func decode(_ inData:Data?) -> dataStore? {
        guard let inData = inData else {
            return nil
        }
        let decodeResult = try! JSONDecoder().decode(dataStore.self, from: inData)
        return decodeResult
    }
    
    class func getNextUrl(_ jsonData:dataStore) -> URL?
    {
        return URL(string: "https://data.gov.sg/\(jsonData.result._links.next)")
    }
    
    class  func getYearlyArray(_ jsonData:dataStore) -> [yearlyRecord]{

        var retVal:[yearlyRecord] = [yearlyRecord]()
        
        let records = jsonData.result.records
        
        repeat {
            if records.count == 0 {
                break
            }
            
            //var initialYear = String(records[0].quarter.split(separator: "-")[0])
            //var dataUsage = 0.0
            for record in records {
                let arrStr = record.quarter.split(separator: "-")
                if arrStr.count > 0 {
                    let sYear = String(arrStr[0])
                    //if sYear != initialYear {
                    let dataUsage = Double(record.volume_of_mobile_data)!
                    let rec = yearlyRecord(year:sYear, volume_of_mobile_data: "0", total_volume:dataUsage)
                    retVal.append(rec)
                    //initialYear = sYear
                    //dataUsage = Double(record.volume_of_mobile_data)!
                    //}
                    //else {
                    //    dataUsage = dataUsage + Double(record.volume_of_mobile_data)!
                    //}
                }
            }
            //let rec = yearlyRecord(year:initialYear, volume_of_mobile_data: "0", total_volume:dataUsage)
            //retVal.append(rec)
        }while false
        
        return retVal
    }
    
    class  func getGroupYearlyArray(_ yearArray:[yearlyRecord]) -> [yearlyRecord]{
        
        var retVal:[yearlyRecord] = [yearlyRecord]()
        
        repeat {
            if records.count == 0 {
                break
            }
            
            var initialYear = yearArray[0].year
            var dataUsage = 0.0
            for record in yearArray {
                    let sYear = record.year
                    if sYear != initialYear {
                        dataUsage = Double(record.volume_of_mobile_data)!
                        let rec = yearlyRecord(year:sYear, volume_of_mobile_data: "0", total_volume:dataUsage)
                        retVal.append(rec)
                        initialYear = sYear
                        dataUsage = record.total_volume
                    }
                    else {
                        dataUsage = dataUsage + Double(record.volume_of_mobile_data)!
                    }
                }
            }
            //let rec = yearlyRecord(year:initialYear, volume_of_mobile_data: "0", total_volume:dataUsage)
            //retVal.append(rec)
        }while false
        
        return retVal
    }

}
