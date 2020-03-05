//
//  Peripheral_List.swift
//  BLEProject_2
//
//  Created by Mohammed Ashfaq on 23/01/1440 AH.
//  Copyright © 1440 Mohammed Ashfaq. All rights reserved.
//

import UIKit
import CoreBluetooth

class Peripheral_List: UITableViewController, CBCentralManagerDelegate
{
    

    
    var centralManager: CBCentralManager!
    
    private var peripherals:[CBPeripheral] = []
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state {
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil)
        default:
            print ("Bluetooth is OFF")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(peripheral)
        print (peripheral)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peripherals.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test"

        // Configure the cell...

        return cell
    }
    
}


