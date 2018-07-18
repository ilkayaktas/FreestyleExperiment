//
//  CalculationTableViewController.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 18.07.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import UIKit

class CalculationTableViewController: UIViewController {

    var refCurrency : CurrencyModel?
    var refValue : Double?

    @IBOutlet weak var refCurrencyLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        flagImage.image = UIImage(named: (refCurrency?.code)!)
        refCurrencyLabel.text = "\((refCurrency?.code)!) \(refValue!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
