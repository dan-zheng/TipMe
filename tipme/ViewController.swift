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
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
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
        

        if (!defaults.bool(forKey: "tipPercentage")) {
            defaults.set(Float(0.20), forKey: "tipPercentage")
            defaults.synchronize()
        }
        tipSlider.value = defaults.float(forKey: "tipPercentage")
        
        billField.placeholder = currencySymbol
        
        if (defaults.bool(forKey: "bill")) {
            billField.text = String(format: "%.2f", defaults.double(forKey: "bill"))
            calculateTip(billField)
        } else {
            billField.becomeFirstResponder()
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            topHeight = keyboardSize.origin.y - keyboardSize.height
            fullHeight = keyboardSize.origin.y
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
        changeViewState()
        defaults.set(Double(billField.text!), forKey: "bill")
        defaults.synchronize()
        calculateTip(billField)
    }
    
    @IBAction func onTipChange(_ sender: AnyObject) {
        let tipPercent = Float(round(tipSlider.value * 100))
        defaults.set(tipPercent/100, forKey: "tipPercentage")
        defaults.synchronize()
        tipPercentLabel.text = String(format: "%.f%%", tipPercent)
        calculateTip(tipSlider)
    }
    
    func changeViewState() {
        if (billField.text != nil && billField.text != "") {
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseOut], animations: {
                self.tipSlider.isHidden = false
                self.tipTextLabel.isHidden = false
                self.tipPercentLabel.isHidden = false
                self.billViewHeight.constant = self.topHeight! - 200
                self.billFieldTop.constant = 82
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseOut], animations: {
                self.tipSlider.isHidden = true
                self.tipTextLabel.isHidden = true
                self.tipPercentLabel.isHidden = true
                self.billViewHeight.constant = self.fullHeight!
                self.billFieldTop.constant = self.topHeight! - 100 - 16
                self.view.layoutIfNeeded()
            })
        }
        print(billField.frame.origin.y)
        print(billField.frame.height)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        //print(billField.font!)
        let bill = defaults.double(forKey: "bill")
        let tipValue = defaults.double(forKey: "tipPercentage")
        let tip = bill * tipValue
        let total = bill + tip
        
        tipValueLabel.text = String(format: "%@%.2f", currencySymbol!, tip)
        totalLabel.text = String(format: "%@%.2f", currencySymbol!, total)
    }
}

