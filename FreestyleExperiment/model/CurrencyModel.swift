//
//  CurrencyModel.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 1.07.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import Foundation

struct CurrencyModel: Codable{
    var code : String
    var name : String
    var buying : Double
    var selling : Double
    
    init() {
        code = ""
        name = ""
        buying = 0
        selling = 0
    }
    
    init(code: String, name: String, buying: Double, selling: Double) {
        self.name = name
        self.code = code
        self.buying = buying
        self.selling = selling
    }
}
