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
}
