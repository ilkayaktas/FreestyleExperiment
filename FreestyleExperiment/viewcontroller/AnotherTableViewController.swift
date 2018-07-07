//
//  AnotherTableViewController.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 1.07.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import UIKit

class AnotherTableViewController: UITableViewController {

    var currencies:[CurrencyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "Custom Title by IA"
        
        //Implementing URLSession
        let urlString = "https://www.doviz.com/api/v1/currencies/all/latest"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let currencyData = try JSONDecoder().decode([CurrencyListElement].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    // print(currencyData)
                    // convert api model to app model
                    for cur in currencyData {
                        self.currencies.append(CurrencyModel(code: cur.code, name: cur.fullName, buying: Double(round(cur.buying*10000)/10000), selling: Double(round(cur.selling*10000)/10000)))
                    }
                    
                    self.tableView.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
        //End implementing URLSession

        // ###########
        
        
        let urlString1 = "http://www.tcmb.gov.tr/kurlar/today.xml"
        guard let url1 = URL(string: urlString1) else { return }
        
        URLSession.shared.dataTask(with: url1) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            print(data)
            
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCellIdentifier", for: indexPath) as! CurrencyCell

        let currency = currencies[indexPath.row]
        cell.currency = currency

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
