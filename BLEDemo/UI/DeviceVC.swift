//
//  ViewController.swift
//  BLEDemo
//
//  Created by Jindrich Dolezy on 11/04/2018.
//  Copyright © 2018 Dzindra. All rights reserved.
//

import UIKit
import UserNotifications
import Toast_Swift

enum typeCellDevice: Int {
    case Manufacture = 0
    case DeviceModel = 1
    case SerialNumber = 2
    case Emei = 3
    case BikeID = 4
    case MAC = 5
    case CCID = 6
    case FWVersion = 7
    case BuildConfig = 8
    case BikeStatus = 9
    case Command = 10
    case Response = 11
    case DateTime = 12
    case Trip = 13
    case Speed = 14
    case ODO = 15
    case Battery = 16
    case Latitude = 17
    case Longitude = 18
    case LTE = 19
    case Button = 20
}


class DeviceVC: UIViewController {
    
    enum ViewState: Int {
        case disconnected
        case connected
        case ready
    }
    
    var device: BTDevice? {
        didSet {
            navigationItem.title = device?.name ?? "Device"
            device?.delegate = self
        }
    }
    
    @IBOutlet weak var tbvDevice: UITableView!
    
    let listTypeCell:[typeCellDevice] = [.Manufacture, .DeviceModel, .SerialNumber, .Emei, .BikeID, .MAC, .CCID, .FWVersion, .BuildConfig,
                                         .BikeStatus, .Command, .Response, .DateTime, .Trip, .Speed, .ODO, .Battery, .Latitude, .Longitude, .LTE, .Button]
//    var cellLabel = LableTableViewCell()
    var cellTextField = TextFieldTableViewCell()
    
    var strManufacture: String?
    var strDeviceModel: String?
    var strSerialNumber: String?
    var strBikeID: String?
    var strMAC: String?
    var strCCID: String?
    var strFWVersion: String?
    var strBuildConfig: String?
    var strBikeStatus: String?
    var strDateTime: String?
    var strTrip: String?
    var strSpeed: String?
    var strODO: String?
    var strBatterry: String?
    var strLat: String?
    var strLong: String?
    var strLTE: String?
    var strEmei: String?
    var strCommand: String?
    var strResponse: String?
    
    var isShowKeyboard = false
    var countCommand = 1
    //    var isReceiveBikeID = false
    var countNotifiers = 0
    var viewState: ViewState = .disconnected {
        didSet {
            switch viewState {
            case .disconnected:
                break
            case .connected:
                break
            case .ready:
                
                break
            }
        }
    }
    
    deinit {
        device?.disconnect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewState = .disconnected
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tbvDevice.reloadData()
    }
    
    func setupTableView(){
        self.tbvDevice.register(UINib(nibName: "LableTableViewCell", bundle: nil), forCellReuseIdentifier: "LableTableViewCell")
        self.tbvDevice.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        self.tbvDevice.register(UINib(nibName: "TextField1TableViewCell", bundle: nil), forCellReuseIdentifier: "TextField1TableViewCell")
        self.tbvDevice.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
        
        self.tbvDevice.delegate = self
        self.tbvDevice.dataSource = self
        self.tbvDevice.separatorColor = UIColor.clear
        self.tbvDevice.separatorInset = UIEdgeInsets.zero
        self.tbvDevice.estimatedRowHeight = 300
        self.tbvDevice.rowHeight = UITableView.automaticDimension
    }
    
    
//    func sendString(){
//        device?.sendString = "BI OK"
//    }
}

extension DeviceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTypeCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typeCell = listTypeCell[indexPath.row]
        switch typeCell {
        
        case .Manufacture:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Manufacture:"
            cell.lbContent.text = strManufacture
            return cell
        case .DeviceModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Device Model:"
            cell.lbContent.text = strDeviceModel
            return cell
        case .SerialNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Serial Number:"
            cell.lbContent.text = self.strSerialNumber
            return cell
        case .Emei:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Emei:"
            cell.lbContent.text = self.strEmei
            return cell
        case .BikeID:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "BikeID:"
            cell.lbContent.text = self.strBikeID
            return cell
        case .MAC:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "MAC:"
            cell.lbContent.text = strMAC
            return cell
        case .CCID:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "CCID:"
            cell.lbContent.text = strCCID
            return cell
        case .FWVersion:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "FW Version:"
            cell.lbContent.text = strFWVersion
            return cell
        case .BuildConfig:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Build Config:"
            cell.lbContent.text = strBuildConfig
            cell.delegate = self
            return cell
        case .BikeStatus:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Bike Status:"
            cell.lbContent.text = self.strBikeStatus
            return cell
        case .Command:
            cellTextField = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell") as! TextFieldTableViewCell
            cellTextField.lbTitle.text = "Command:"
            cellTextField.tfInput.delegate = self
            cellTextField.delegate = self
            cellTextField.setupTypeDropdown()
            return cellTextField
        case .Response:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextField1TableViewCell") as! TextField1TableViewCell
            cell.lbTitle.text = "Response:"
            cell.tfInput.text = strResponse
            cell.tfInput.delegate = self
            return cell
        case .DateTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Date time:"
            cell.lbContent.text = strDateTime
            return cell
        case .Trip:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Trip:"
            cell.lbContent.text = strTrip
            return cell
        case .Speed:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Speed:"
            cell.lbContent.text = strSpeed
            return cell
        case .ODO:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "ODO:"
            cell.lbContent.text = strODO
            return cell
        case .Battery:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Batterry:"
            cell.lbContent.text = strBatterry
            return cell
        case .Latitude:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Latitude:"
            cell.lbContent.text = strLat
            return cell
        case .Longitude:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "Longitude:"
            cell.lbContent.text = strLong
            return cell
        case .LTE:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LableTableViewCell") as! LableTableViewCell
            cell.lbTitle.text = "LTE:"
            cell.lbContent.text = strLTE
            return cell
        case .Button:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as! ButtonTableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
    }
    
    
}

extension DeviceVC: ButtonTableViewCellProtocol{
    func didButton() {
        print("did button")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hhmmssddMMyy"
        let dateString = formatter.string(from: date)
        print("gewg = \(dateString)")
//        self.tfInputCommand.text =  "SET_TIME \(dateString)"
        device?.sendCommandString = "SET_TIME \(dateString)"
    }
}

extension DeviceVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        isShowKeyboard = true
        if textField == cellTextField.tfInput {
            cellTextField.showType()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("text field = \(textField)")
        
        if (textField.text!.isEmpty && textField == cellTextField.tfInput) {
            cellTextField.showType()
        }
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        isShowKeyboard = false
    }
}

extension DeviceVC: LableTableViewCellProtocol{
    func getText(_ str: String) {
        
    }
    
    func showPopup() {
        if self.strBuildConfig?.isEmpty != nil{
            let str = strBuildConfig
            self.view.makeToast(str?.replacingOccurrences(of: ",", with: "\n"))
        }
    }
    
    
}

extension DeviceVC: TextFieldTableViewCellProtocol{
    func getTextField(_ str: String) {
        print("strrrr = \(str)")
        self.strCommand = str
    }
    
    func didSend() {
        self.view.endEditing(true)
        device?.sendCommandString = self.strCommand?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}

extension DeviceVC: BTDeviceDelegate {
    func deviceReponseCommand(value: String) {
        self.strResponse = value
        let arrTemp = value.split(separator: " ")
        if (arrTemp[0] == "GET_IMEI_MAC" && arrTemp.count > 2)  {
            cellTextField.strImeiMAC = String(arrTemp[2])
            cellTextField.tfInput.text = cellTextField.strImeiMAC
            
        }
        if arrTemp.count > 7 {
            for (index, item) in arrTemp.enumerated() {
                switch index {
                case 0:
                    
                    break
                case 1:
                    break
                case 2:
                    self.strEmei = "\(item)"
                    break
                case 3:
                    self.strCCID = "\(item)"
                    break
                case 4:
                    self.strMAC = "\(item)"
                    break
                case 5:
                    self.strBikeID = "\(item)"
                    break
                case 6:
                    self.strFWVersion = "\(item)"
                    break
                case 7:
                    self.strBuildConfig = "\(item)"
                    break
                case 8:
                    break
                case 9:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func deviceManufactureChanged(value: String) {
//        self.lbManufacturer.text = value
        strManufacture = value
    }
    
    func deviceDeviceNameChanged(value: String) {
//        self.lbDeviceName.text = value
        self.strDeviceModel = value
    }
    
    func countNotify() {
        self.countNotifiers = self.countNotifiers + 1
//        self.lbCountNotify.text = "\(self.countNotifiers)"
        self.strBikeStatus = "\(self.countNotifiers)"
        if !isShowKeyboard {
            self.tbvDevice.reloadData()
        }
    }
    
    func getFullInfo(value: String){
        if value.count > 0 {
            let arrTemp = value.split(separator: ",")
            if arrTemp.count > 7 {
                for (index, item) in arrTemp.enumerated() {
                    switch index {
                    case 0:
                        self.strDateTime = String(item)
                        break
                    case 1:
                        self.strTrip = "\(Float(item)!/10) km"
                        break
                    case 2:
                        self.strSpeed = "\(Float(item)!/10) km/h"
                        break
                    case 3:
                        self.strODO = "\(item) km"
                        break
                    case 4:
                        self.strBatterry = "\(item)%"
                        break
                    case 5:
                        var strLat = "\(item)"
                        let index = strLat.index(strLat.startIndex, offsetBy: 0, limitedBy: strLat.endIndex)!
                        strLat.remove(at: index)
                        self.strLat = strLat
                        break
                    case 6:
                        let strLong = "\(item)"
                        let long = strLong.index(after: strLong.startIndex)..<strLong.endIndex
                        self.strLong = String(strLong[long])
                        break
                    case 7:
                        self.strLTE = "\(item)"
                        break
                    default:
                        break
                    }
                }
            }
            
        }
    }
    
//    func getBikeIDFromIOT(value: String) {
//        self.lbBikeID.text = value
//        self.isReceiveBikeID = true
//
//        if viewState == .ready {
//            self.sendString()
//            self.isReceiveBikeID = false
//        }
//    }
    
    func deviceSerialChanged(value: String) {
//        lbSerialNumber.text = value
        self.strSerialNumber = value
    }
    
    
    func deviceConnected() {
        viewState = .connected
    }
    
    func deviceDisconnected() {
        viewState = .disconnected
    }
    
    func deviceReady() {
        viewState = .ready
    }
    
    func deviceBlinkChanged(value: Bool) {
        
        if UIApplication.shared.applicationState == .background {
            let content = UNMutableNotificationContent()
            content.title = "ESP Blinky"
            content.body = value ? "Now blinking" : "Not blinking anymore"
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("DeviceVC: failed to deliver notification \(error)")
                }
            }
        }
    }
    
    
}
