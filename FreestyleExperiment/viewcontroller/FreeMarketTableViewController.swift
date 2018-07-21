//
//  FreeMarketTableViewController.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 1.07.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import UIKit

class FreeMarketTableViewController: UITableViewController {

    var currencies:[CurrencyModel] = []
    var refCurrency: CurrencyModel?
    var refValue: Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

        refreshControl = UIRefreshControl()
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl!)
        }

        // Configure Refresh Control
        refreshControl?.addTarget(self, action: #selector(refreshCurrencyData(_:)), for: .valueChanged)
    }

    @objc private func refreshCurrencyData(_ sender: Any) {
        // Fetch Weather Data
        loadData()
    }

    func loadData(){
        let urlString = "https://www.doviz.com/api/v1/currencies/all/latest"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }

            //Implement JSON decoding and parsing
            do {
                //Decode retrieved data with JSONDecoder and assing type of Article object
                let currencyData = try JSONDecoder().decode([CurrencyListElement].self, from: data)
                self.currencies.removeAll()

                //Get back to the main queue
                DispatchQueue.main.async {
                    // print(currencyData)
                    // convert api model to app model
                    for cur in currencyData {
                        self.currencies.append(CurrencyModel(code: cur.code, name: cur.fullName, buying: Double(round(cur.buying*10000)/10000), selling: Double(round(cur.selling*10000)/10000)))
                    }

                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }

            } catch let jsonError {
                print(jsonError)
            }

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow

        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as! CurrencyCell



        let alertController = UIAlertController(title: "\((currentCell.currency?.name)!)", message: "Hesaplamak istediğiniz miktarı giriniz!" , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Hesapla", style: .default, handler: { (action:UIAlertAction) in

            self.refCurrency = currentCell.currency!
            self.refValue = Double(alertController.textFields![0].text!)
            self.performSegue(withIdentifier: "CalculateScreenSegueIdentifier", sender: FreeMarketTableViewController.self)

        })
        let cancelAction = UIAlertAction(title: "İptal", style: .default, handler: { (action:UIAlertAction) in
            print(currentCell.currency)
        })
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { (textField) in
            textField.placeholder = "Hesaplanacak döviz miktarı..."
            textField.keyboardType = .numberPad
        }
        present(alertController, animated: true, completion: nil)

    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalculateScreenSegueIdentifier"{
            var vc = segue.destination as! CalculationTableViewController
            vc.refCurrency = refCurrency
            vc.refValue = refValue
            vc.currencies = calculateCurrencies(refCurrency: refCurrency!, refValue: refValue!)
        }

    }

    @objc func refresh(sender:AnyObject) {
        loadData()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
}

// unwind methods. These are used from PlayerDetailsView
extension FreeMarketTableViewController {
    
    @IBAction func doneByCalculatorScreen(_ segue: UIStoryboardSegue) {
        print("Welcome back CurrencyCalculatorScreen!")
    }

    func calculateCurrencies(refCurrency : CurrencyModel, refValue : Double) -> [CurrencyModel]{
        var calculatedCurrencies:[CurrencyModel] = []
        calculatedCurrencies.append(CurrencyModel(code: "TRY", name: "Türk Lirası",
                                                    buying: refValue*refCurrency.buying,
                                                    selling: refValue*refCurrency.selling))

        for currency in currencies {
            var resultByRefValueBuying = currency.buying / refCurrency.buying
            var resultByRefValueSelling = currency.selling / refCurrency.selling

            var resultBuying = refValue / resultByRefValueBuying
            var resultSelling = refValue / resultByRefValueSelling

            calculatedCurrencies.append(CurrencyModel(code: currency.code, name: currency.name, buying: resultBuying, selling: resultSelling))
        }

        return calculatedCurrencies
    }
}
