//
//  ViewController.swift
//  BLEProject_2
//
//  Created by Mohammed Ashfaq on 23/01/1440 AH.
//  Copyright © 1440 Mohammed Ashfaq. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    var centralManager: CBCentralManager!
    
    @IBOutlet weak var bluetoothState: UILabel!

    
    @IBAction func Scanbutton(_ sender: Any)
    {
        let peripheralList = self.storyboard?.instantiateViewController(withIdentifier: "ConnectionViewController") as! ConnectionViewController
        self.navigationController?.pushViewController(peripheralList, animated: true)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


