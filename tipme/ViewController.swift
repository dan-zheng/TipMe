//
//  ViewController.swift
//  tipme
//
//  Created by Dan Zheng on 12/1/16.
//  Copyright © 2016 Dan Zheng. All rights reserved.
//

import UIKit
import ValueStepper

class ViewController: UIViewController {
    
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipSlider: UISlider!
    
    @IBOutlet weak var billViewHeight: NSLayoutConstraint!
    @IBOutlet weak var billFieldTop: NSLayoutConstraint!
    
    let tipPercentage = [0.15, 0.20, 0.25]
    
    let defaults = UserDefaults.standard
    
    let formatter = NumberFormatter()
    
    var locale = Locale.current
    var currencySymbol: String?
    
    var topHeight: CGFloat?
    var fullHeight: CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locale = Locale.current
        currencySymbol = locale.currencySymbol
        
        if (!defaults.bool(forKey: "tip_percentage")) {
            defaults.set(tipPercentage[tipControl.selectedSegmentIndex], forKey: "default_tip_percentage")
        } else {
            tipControl.selectedSegmentIndex = tipPercentage.index(of: defaults.double(forKey: "tip_percentage")) ?? 1
        }
        
        billField.becomeFirstResponder()
        
        if (defaults.bool(forKey: "bill")) {
            billField.text = String(format: "%@%.2f", currencySymbol!, defaults.double(forKey: "bill"))
            billField.text = String(format: "%.2f", defaults.double(forKey: "bill"))
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //print(keyboardSize)
            //print(keyboardSize.origin.y)
            topHeight = keyboardSize.origin.y - keyboardSize.height
            fullHeight = keyboardSize.origin.y
            //billViewHeight.constant = topHeight! - 200
            //billView.setNeedsLayout()
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
        /*
        defaults.set(Double(billField.text!), forKey: "bill")
        print(defaults.double(forKey: "bill"))
        defaults.synchronize()
        calculateTip(billField)
 */
    }
    
    @IBAction func onControlTap(_ sender: AnyObject) {
        defaults.set(tipPercentage[tipControl.selectedSegmentIndex], forKey: "tip_percentage")
        defaults.synchronize()
        calculateTip(tipControl)
    }
    
    @IBAction func onTipChange(_ sender: AnyObject) {
        print(tipSlider.value)
        let tipPercent = Float(round(tipSlider.value * 100))
        tipPercentLabel.text = String(format: "%.f%%", tipPercent)
    }
    
    func changeViewState() {
        if (billField.text != nil && billField.text != "") {
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseOut], animations: {
                self.tipControl.isHidden = false
                self.billViewHeight.constant = self.topHeight! - 200
                self.billFieldTop.constant = 82
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseOut], animations: {
                self.tipControl.isHidden = true
                self.billViewHeight.constant = self.fullHeight!
                self.billFieldTop.constant = self.topHeight! - 100 - 16
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        changeViewState()
        //print(billField.font!)
        let bill = defaults.double(forKey: "bill")
        let tipValue = defaults.double(forKey: "tip_percentage")
        let tip = bill * tipValue
        let total = bill + tip
        
        tipValueLabel.text = String(format: "%@%.2f", currencySymbol!, tip)
        totalLabel.text = String(format: "%@%.2f", currencySymbol!, total)
    }
}

