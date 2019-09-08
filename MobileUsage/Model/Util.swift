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
        var decodeResult:dataStore?
        do {
            decodeResult = try JSONDecoder().decode(dataStore.self, from: inData)
        }catch {
            print("no data")
        }
        return decodeResult
    }
    
    class func getNextUrl(_ jsonData:dataStore) -> URL?
    {
        return URL(string: "https://data.gov.sg\(jsonData.result._links.next)")
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
                    let dataUsage = Double(record.volume_of_mobile_data)!
                    let rec = yearlyRecord(year:sYear, volume_of_mobile_data: record.volume_of_mobile_data, total_volume:dataUsage)
                    retVal.append(rec)
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
            if yearArray.count == 0 {
                break
            }
            
            var initialYear = yearArray[0].year
            var initialQData = ""
            var dataUsage = 0.0
            for record in yearArray {
                let sYear = record.year
                if sYear != initialYear {
                    //dataUsage = record.total_volume
                    let rec = yearlyRecord(year:initialYear, volume_of_mobile_data: initialQData, total_volume:dataUsage)
                    retVal.append(rec)
                    initialYear = sYear
                    initialQData = record.volume_of_mobile_data
                    dataUsage = record.total_volume
                }
                else {
                    dataUsage = dataUsage + record.total_volume
                    initialQData = initialQData + "," + record.volume_of_mobile_data
                }
            }
            let rec = yearlyRecord(year:initialYear, volume_of_mobile_data: initialQData, total_volume:dataUsage)
            retVal.append(rec)
        }while false
        
        return retVal
    }
    
    class func containDecreaseQData(_ inData:String) -> Bool {
        let arr = inData.split(separator: ",")
        if arr.count == 1 {
            return false
        }
        
        for n in 0...(arr.count-2)  {
            let q1 = Double(arr[n])!
            let q2 = Double(arr[n + 1])!
            if q2 < q1 {
                return true
            }
        }
        return false
    }
}
