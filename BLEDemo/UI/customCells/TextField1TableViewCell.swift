//
//  TextField1TableViewCell.swift
//  BLEDemo
//
//  Created by Lê Hùng on 09/12/2020.
//  Copyright © 2020 Dzindra. All rights reserved.
//

import UIKit

protocol TextField1TableViewCellProtocol {
    func getTextField1(_ str: String)
}

class TextField1TableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfInput: UITextField!
    var delegate: TextField1TableViewCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
