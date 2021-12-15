//
//  FirstViewController.swift
//  LocationSpoofer
//
//  Created by Richard Ondrejka on 07.12.2021.
//  Copyright © 2021 Richard Ondrejka. All rights reserved.
//

import UIKit

extension LosslessStringConvertible{
    var string: String { .init(self)}
}

class FirstViewController: UIViewController {
    
    var locationFileManager : LocationFileManager!
    @IBOutlet weak var enabledLabel: UILabel!
    @IBOutlet weak var enabledSwitchValue: UISwitch!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var altitude: UITextField!
    
    @IBAction func enabledSwitchAction(_ sender: UISwitch) {
        
        if (sender.isOn == true){
            enabledLabel.text = "Enabled"
            locationFileManager.locationDict.updateValue(1, forKey: "enabled")
            
        } else {
            enabledLabel.text = "Disabled"
            locationFileManager.locationDict.updateValue(0, forKey: "enabled")
        }
        
        locationFileManager.updateLocationFile()
    }
    
    
    @IBAction func buttonSaveChanges(_ sender: UIButton) {
        locationFileManager.locationDict.updateValue(Double((latitude.text! as NSString).doubleValue), forKey: "latitude")
        locationFileManager.locationDict.updateValue(Double((longitude.text! as NSString).doubleValue), forKey: "longitude")
        locationFileManager.locationDict.updateValue(Double((altitude.text! as NSString).doubleValue), forKey: "altitude")
        
        locationFileManager.updateLocationFile()
    }
    
    
    
    @IBAction func pickLocationFromMapButton(_ sender: Any) {
        performSegue(withIdentifier: "second", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! SecondViewController
        viewController.locationFileManager = locationFileManager
        viewController.callback = {
            self.updateTextFields()
        }
    }
    
    func updateTextFields(){
        latitude.keyboardType = .numbersAndPunctuation
        longitude.keyboardType = .numbersAndPunctuation
        altitude.keyboardType = .numbersAndPunctuation
        latitude.text = locationFileManager.locationDict["latitude"]?.string
        longitude.text = locationFileManager.locationDict["longitude"]?.string
        altitude.text = locationFileManager.locationDict["altitude"]?.string
    }
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        locationFileManager = LocationFileManager()

        let isEnabled = round(locationFileManager.locationDict["enabled"]!) == 1
        enabledSwitchValue.setOn(isEnabled, animated: false)
        enabledLabel.text = isEnabled ? "Enabled" : "Disabled"
        
        updateTextFields()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer){
        latitude.resignFirstResponder()
        longitude.resignFirstResponder()
        altitude.resignFirstResponder()
    }
    
}
