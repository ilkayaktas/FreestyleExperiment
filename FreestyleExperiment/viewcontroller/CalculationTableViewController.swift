//
//  CalculationTableViewController.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 18.07.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import UIKit

class CalculationTableViewController: UIViewController, UITableViewDataSource {

    var refCurrency : CurrencyModel?
    var refValue : Double?
    var currencies:[CurrencyModel] = []

    @IBOutlet weak var refCurrencyLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        flagImage.image = UIImage(named: (refCurrency?.code)!)
        refCurrencyLabel.text = "\((refCurrency?.code)!) \(refValue!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatedCurrencyCellIdentifier", for: indexPath) as! CurrencyCell

        let currency = currencies[indexPath.row]
        cell.currency = currency

        return cell
    }




}
