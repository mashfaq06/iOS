//
//  ConnectionViewController.swift
//  BLEProject_2
//
//  Created by Mohammed Ashfaq on 29/11/2018.
//  Copyright © 2018 Mohammed Ashfaq. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate
{
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var button: UIButton!
    var centralManager: CBCentralManager!
    var peripheralManager: CBPeripheralManager!
    var BTname:[String] = [ ]
    var BTRSSIs:[NSNumber] = []
    var connectPeripheral : CBPeripheral!
    var BTconnect : [CBPeripheral?] = []
    var BTconnection : CBPeripheral!
    var BTCharacteristics: CBCharacteristic!
    var rssiTimer: Timer?
    var value: UInt8!
    
    //var data: Data!
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn
        {
            startScan()
        }
        else
        {
            let alert = UIAlertController(title: "Bluetooth is OFF", message: "Make sure you turn on bluetooth", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { ( action ) in alert.dismiss(animated: true, completion: nil) })
            
            alert.addAction(action)
            present(alert,animated: true,completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BTname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PeripheralTableViewCell
        {
            cell.nameLabel.text = BTname[indexPath.row]
            cell.rssiLabel.text = "\(BTRSSIs[indexPath.row])"
            
            return cell
        }
        return UITableViewCell()
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        print(peripheral)
        connectPeripheral = peripheral
        BTconnect.append(connectPeripheral)
        connectPeripheral.delegate = self
        
        if let name = peripheral.name
        {
            BTname.append(name)
            
        }
        else
        {
            BTname.append(peripheral.identifier.uuidString)
        }
        BTRSSIs.append(RSSI)
        tableView.reloadData()
    }
    
    func startScan()
    {
        BTname = []
        BTRSSIs = []
        tableView.reloadData()
        centralManager.stopScan()
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        BTconnection = BTconnect[indexPath.row]!
        centralManager.connect(BTconnection, options: nil)
        print(BTconnection)
        
    

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        print("CONNECTED")
        //print(peripheral)
        BTconnection.discoverServices(nil)
        
        peripheral.readRSSI()
        rssiTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (Timer) in
            peripheral.readRSSI()
        })
        progressBar.setProgress(0, animated: true)
        centralManager.stopScan()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        guard let services = peripheral.services
            else
        {
            return
        }
        for service in services
        {
            //print(service)
            BTconnection.discoverCharacteristics(nil, for: service)
            
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        
        
        if (RSSI == 0) {
            print("-1.0"); // if we cannot determine accuracy, return -1.
        }
        
        let ratio = Double(truncating: RSSI)*1.0/(-65);
        progressBar.progress = Float(1/ratio)
        if (ratio < 1.0) {
            //print("less than one")
            //progressBar.progress = Float(ratio/10)
            print(pow(ratio, 10));
        }
        else {
            //print("greater than 1")
            let accuracy =  (0.89976)*pow(ratio, 7.7095) + 0.111;
            //progressBar.progress = Float(accuracy/10)
            print(accuracy);
            
        }
    }
    
    func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        print(peripheral.readRSSI())
    }

    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        guard let characteristics = service.characteristics else
        {
            return
            
        }
        for characteristic in characteristics
        {
            //print(characteristic)
        
            
            if characteristic.properties.contains(.writeWithoutResponse)
            {
                
                
                BTCharacteristics = characteristic
                print("*** \(characteristic.uuid): properties contains .write ***")
                //var parameter = NSInteger(01)
                //let data = NSData(bytes: &parameter, length: 1)
                //print(data)
                
                //characteristic.willChangeValue(for: characteristic)
                //let somecharacteristics = CBMutableCharacteristic.init(type: characteristic.uuid, properties: CBCharacteristicProperties(rawValue: CBCharacteristicProperties.read.rawValue|CBCharacteristicProperties.write.rawValue), value: nil, permissions: CBAttributePermissions(rawValue: CBAttributePermissions.readable.rawValue|CBAttributePermissions.writeable.rawValue))
                //let text = "02"
                //let data = text.data(using: String.Encoding.utf8)
                //let hexString = data.map{ String(format:"%02x", $0 as CVarArg) }!.joined()
                
                let value: UInt8 = 1
                let data = Data(bytes: [value])
                    print("FOUND")
                print(data)
                    //print(characteristic.value ?? "No Value")
                peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
                //peripheralManager.updateValue(data!, for: somecharacteristics, onSubscribedCentrals: nil)
                    peripheral.setNotifyValue(true, for: characteristic)
                
                
            }

           
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("PRINTING")
        print(characteristic)
        if (error != nil)
        {
            print(error!)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        print("Printing")
        print(characteristic)
        if (error != nil)
        {
            print(error!)
        }
    }
    
    @IBAction func WriteCharc(_ sender: UIButton)
    {
        let byteString = textField.text!
        switch byteString {
        case "2":
            value = 0x02
            break
        case "02":
            value = 0x02
            break
        case "0x02":
            value = 0x02
            break
        case "1":
            value = 0x01
            break
        case "01":
            value = 0x01
            break
        case "0x01":
            value = 0x01
            break
        default:
            value = 0x00
        }
        let data = Data(bytes: [value])
        BTconnection.writeValue(data, for: BTCharacteristics, type: .withoutResponse)
        BTconnection.setNotifyValue(true, for: BTCharacteristics)
    }
    
    
}//End of Class
