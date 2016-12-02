//
//  ViewController.swift
//  tipme
//
//  Created by Dan Zheng on 12/1/16.
//  Copyright © 2016 Dan Zheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let tipPercentage = [0.18, 0.20, 0.25]
    
    let defaults = UserDefaults.standard
    
    let formatter = NumberFormatter()
    
    var locale = Locale.current
    var currencySymbol: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locale = Locale.current
        currencySymbol = locale.currencySymbol
        
        if (!defaults.bool(forKey: "tip_percentage")) {
            defaults.set(tipPercentage[tipControl.selectedSegmentIndex], forKey: "default_tip_percentage")
        } else {
            tipControl.selectedSegmentIndex = tipPercentage.index(of: defaults.double(forKey: "tip_percentage")) ?? 1
        }
        
        if (defaults.bool(forKey: "bill")) {
            print(defaults.double(forKey: "bill"))
            billField.text = String(format: "%@%.2f", currencySymbol!, defaults.double(forKey: "bill"))
            billField.text = String(format: "%.2f", defaults.double(forKey: "bill"))
            calculateTip(billField)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true);
    }

    @IBAction func onBillChange(_ sender: AnyObject) {
        defaults.set(Double(billField.text!), forKey: "bill")
        print(defaults.double(forKey: "bill"))
        defaults.synchronize()
        calculateTip(billField)
    }
    
    @IBAction func onControlTap(_ sender: AnyObject) {
        defaults.set(tipPercentage[tipControl.selectedSegmentIndex], forKey: "tip_percentage")
        defaults.synchronize()
        calculateTip(tipControl)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        print(billField.font!)
        let bill = defaults.double(forKey: "bill")
        let tipValue = defaults.double(forKey: "tip_percentage")
        let tip = bill * tipValue
        let total = bill + tip
        
        tipLabel.text = String(format: "%@%.2f", currencySymbol!, tip)
        totalLabel.text = String(format: "%@%.2f", currencySymbol!, total)
    }
}

