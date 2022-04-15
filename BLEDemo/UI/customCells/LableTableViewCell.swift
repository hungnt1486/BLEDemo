//
//  LableTableViewCell.swift
//  BLEDemo
//
//  Created by Lê Hùng on 09/12/2020.
//  Copyright © 2020 Dzindra. All rights reserved.
//

import UIKit

protocol LableTableViewCellProtocol {
    func getText(_ str: String)
    func showPopup()
}

class LableTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    var delegate: LableTableViewCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touchLabel))
        self.lbContent.isUserInteractionEnabled = true
        self.lbContent.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func touchLabel(){
        delegate?.showPopup()
    }
    
}
