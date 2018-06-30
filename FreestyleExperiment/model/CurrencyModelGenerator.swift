//
//  CurrencyModelGenerator.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 1.07.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import Foundation

final class CurrencyModelGenerator {
    static func generateData() -> [CurrencyModel]{
        return [
            CurrencyModel(code: "USD", name: "US DOLLAR", buying: 4.5575, selling: 4.5758),
            CurrencyModel(code: "CHF", name: "SWISS FRANK", buying: 4.5721, selling: 4.6153),
            CurrencyModel(code: "EUR", name: "EURO", buying: 5.3055, selling: 5.3268),
            CurrencyModel(code: "GBP", name: "POUND STERLING", buying: 5.9768, selling: 6.0212)
        ]
    }
}
