//
//  CurrencyCell.swift
//  FreestyleExperiment
//
//  Created by İlkay Aktaş on 1.07.2018.
//  Copyright © 2018 İlkay Aktaş. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var buyingLabel: UILabel!
    @IBOutlet weak var sellingLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    var currency: CurrencyModel? {
        didSet {
            guard let currency = currency else { return }
            
            nameLabel.text = currency.name
            codeLabel.text = currency.code
            if(currency.buying >= 1000 || currency.selling >= 1000){
                buyingLabel.text = String(format: "%.1f", currency.buying)
                sellingLabel.text = String(format: "%.1f", currency.selling)
            } else if(currency.buying >= 100 || currency.selling >= 100){
                buyingLabel.text = String(format: "%.2f", currency.buying)
                sellingLabel.text = String(format: "%.2f", currency.selling)
            } else if(currency.buying >= 10 || currency.selling >= 10){
                buyingLabel.text = String(format: "%.3f", currency.buying)
                sellingLabel.text = String(format: "%.3f", currency.selling)
            } else {
                buyingLabel.text = String(format: "%.4f", currency.buying)
                sellingLabel.text = String(format: "%.4f", currency.selling)
            }

            
            flagImageView.image = image(forRating: currency.code)
        }
    }
    
    func image(forRating code: String) -> UIImage? {
        return UIImage(named: code)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
