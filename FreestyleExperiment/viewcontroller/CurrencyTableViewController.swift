//
//  CurrencyTableViewController.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 29.06.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {

    var currencies = CurrencyModelGenerator.generateData()
   

}

extension CurrencyTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        print(indexPath.row)
        let currency = currencies[indexPath.row]
        cell.textLabel?.text = currency.name
        cell.detailTextLabel?.text = currency.code
        return cell
    }
}
