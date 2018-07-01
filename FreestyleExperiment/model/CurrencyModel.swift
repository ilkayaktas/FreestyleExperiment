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
}
