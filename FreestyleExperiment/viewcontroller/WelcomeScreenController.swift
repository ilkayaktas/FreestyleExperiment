//
//  ViewController.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 29.06.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import UIKit

class WelcomeScreenController: UIViewController {

   
    @IBAction func onInfoClicked(_ sender: Any) {
        print("Info clicked!")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


// unwind methods. These are used from PlayerDetailsView
extension WelcomeScreenController {
    
    @IBAction func doneByCurrencyCalculatorScreen(_ segue: UIStoryboardSegue) {
        print("Welcome back!")
    }

}

