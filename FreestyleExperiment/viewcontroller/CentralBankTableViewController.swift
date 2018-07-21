//
//  CentralBankTableViewController.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 9.07.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import UIKit

class CentralBankTableViewController: UITableViewController {

    var currentParsingElement: String = ""
    var currencyModel : CurrencyModel?
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
        let urlString1 = "http://www.tcmb.gov.tr/kurlar/today.xml"
        guard let url1 = URL(string: urlString1) else { return }
        self.currencies.removeAll()

        URLSession.shared.dataTask(with: url1) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }

            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()

        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencies.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CentralCellIdentifier", for: indexPath) as! CurrencyCell

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
            self.performSegue(withIdentifier: "CalculateScreenSegueIdentifier", sender: CentralBankTableViewController.self)

        })
        let cancelAction = UIAlertAction(title: "İptal", style: .default, handler: { (action:UIAlertAction) in
            print("İptal edildi!")
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
extension CentralBankTableViewController: XMLParserDelegate{
    
    //MARK:- XML Delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if(elementName == "Currency"){
            if currencyModel == nil {
                currencyModel = CurrencyModel()
            }

            currencyModel?.code = attributeDict["CurrencyCode"]!
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "Isim" {
                currencyModel?.name.append(foundedChar)
            }
            else if currentParsingElement == "BanknoteBuying" {
                currencyModel?.buying = Double(foundedChar)!
            }
            else if currentParsingElement == "BanknoteSelling" {
                currencyModel?.selling = Double(foundedChar)!
            }
            else if currentParsingElement == "ForexBuying" {
                if(currencyModel?.buying == 0){
                    currencyModel?.buying = Double(foundedChar)!
                }
            }
            else if currentParsingElement == "ForexSelling" {
                if(currencyModel?.selling == 0){
                    currencyModel?.selling = Double(foundedChar)!
                }
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "Currency"){
            currencies.append(currencyModel!)
            currencyModel = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    var camelCasedString: String {
        return self.components(separatedBy: " ")
                .map { return $0.lowercased().capitalizingFirstLetter() }
                .joined()
    }
}

// unwind methods. These are used from PlayerDetailsView
extension CentralBankTableViewController {
    
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
