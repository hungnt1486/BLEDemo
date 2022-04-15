//
//  TextFieldTableViewCell.swift
//  BLEDemo
//
//  Created by Lê Hùng on 09/12/2020.
//  Copyright © 2020 Dzindra. All rights reserved.
//

import UIKit
import DropDown

protocol TextFieldTableViewCellProtocol {
    func getTextField(_ str: String)
    func didSend()
}

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfInput: UITextField!
    @IBOutlet weak var btSend: UIButton!
    var strImeiMAC = ""
    var delegate: TextFieldTableViewCellProtocol?
    
    var TypeDropdown = DropDown()
    var arrString: [String] = ["GET_IMEI_MAC", "GET_BIKEID", "SYS_INFO", "SYS_RESET", "CFG_HL 100", "CFG_SL 255 255 255", "CFG_BS 1"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func touchSend(_ sender: Any) {
        delegate?.getTextField(tfInput.text ?? "")
        delegate?.didSend()
    }
    
    func setupTypeDropdown(){
        TypeDropdown.anchorView = self.tfInput
        TypeDropdown.bottomOffset = CGPoint(x: 0, y: self.tfInput.bounds.height)
//            for item in arr {
//                arrString.append(item["name"] ?? "")
//            }
        let typeDataSource = arrString
        TypeDropdown.dataSource = typeDataSource
        TypeDropdown.selectionAction = { [unowned self] (index, item) in
            print("item \(item)")
            let str = "\(self.strImeiMAC) \(item)"
            self.tfInput.text = str//"\(self.tfInput.text ?? "") \(item)"
//            self.lbDateTimeDetail.tag = index
//            self.delegate?.getTextDateTime(index)
        }
    }
        
    @objc func showType(){
        TypeDropdown.show()
    }
    
}
