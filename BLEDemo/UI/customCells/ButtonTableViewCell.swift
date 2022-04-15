//
//  ButtonTableViewCell.swift
//  BLEDemo
//
//  Created by Lê Hùng on 09/12/2020.
//  Copyright © 2020 Dzindra. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellProtocol {
    func didButton()
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var btCurrentTime: UIButton!
    var delegate: ButtonTableViewCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func touchCurrentTime(_ sender: Any) {
        delegate?.didButton()
    }
    
}
