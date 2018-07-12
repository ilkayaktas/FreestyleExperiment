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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    func loadData(){
        let urlString1 = "http://www.tcmb.gov.tr/kurlar/today.xml"
        guard let url1 = URL(string: urlString1) else { return }

        URLSession.shared.dataTask(with: url1) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }

            print(data)

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
            print(currencyModel.debugDescription)
            currencies.append(currencyModel!)
            currencyModel = nil
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
