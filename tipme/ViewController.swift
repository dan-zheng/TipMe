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
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var splitView: UIView!
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    
    @IBOutlet weak var split2Label: UILabel!
    @IBOutlet weak var split3Label: UILabel!
    @IBOutlet weak var split4Label: UILabel!
    @IBOutlet weak var split5Label: UILabel!
    
    @IBOutlet weak var billViewHeight: NSLayoutConstraint!
    @IBOutlet weak var billFieldTop: NSLayoutConstraint!
    
    // Use defaults to save application data
    let defaults = UserDefaults.standard
    
    // Create number formatter for currency
    var formatter = NumberFormatter()
    
    // Helper variables for various heights
    var screenHeight: CGFloat?
    var topHeight: CGFloat?
    var fullHeight: CGFloat?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If there is no default tip percentage, set it to 0.20
        if (!defaults.bool(forKey: "tipPercentage")) {
            defaults.set(Float(0.20), forKey: "tipPercentage")
            defaults.synchronize()
        }
        // Set value of tipSlider to tip percentage
        tipSlider.value = defaults.float(forKey: "tipPercentage")
        tipPercentLabel.text = String(format: "%.f%%", Float(round(tipSlider.value * 100)))
        
        // If there is a default bill value
        if (defaults.bool(forKey: "bill")) {
            // Set billField text to default value and calculate tip
            billField.text = String(format: "%.2f", defaults.double(forKey: "bill"))
            //billField.text = formatter.string(from: NSNumber(value: defaults.double(forKey: "bill")))
            
            calculateTip(billField)
        }
        // If there is no default bill value
        else {
            // Focus on billField
            billField.becomeFirstResponder()
            
            // Hide other views/objects
            self.tipSlider.isHidden = true
            self.tipTextLabel.isHidden = true
            self.tipPercentLabel.isHidden = true
            self.totalView.isHidden = true
            self.splitView.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set formatter
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        // Set placeholder of billField to currency symbol of current locale
        billField.placeholder = formatter.currencySymbol
        
        // Find screen height of device
        screenHeight = UIScreen.main.bounds.height
    }
    
    /**
     * Allow portrait orientation only.
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    /**
     * Helper function for determining height of keyboard
     */
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
    
    /**
     * On tap of screen, end editing of billField
     */
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true);
    }

    @IBAction func onBillChange(_ sender: AnyObject) {
        // Update view state of app based on status of billField
        changeViewState()
        
        // Store text of billFields in defaults
        defaults.set(Double(billField.text!), forKey: "bill")
        defaults.synchronize()
        
        // Calculate tip
        calculateTip(billField)
    }
    
    @IBAction func onTipChange(_ sender: AnyObject) {
        // Calculate tip percentage and store in defaults
        let tipPercent = Float(round(tipSlider.value * 100))
        defaults.set(tipPercent/100, forKey: "tipPercentage")
        defaults.synchronize()
        
        // Update tipPercentLabel text
        tipPercentLabel.text = String(format: "%.f%%", tipPercent)
        
        // Calculate tip
        calculateTip(tipSlider)
    }
    
    func changeViewState() {
        // If billField is empty, hide other views/objects using animation
        if (billField.text != nil && billField.text != "") {
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseOut], animations: {
                self.tipSlider.isHidden = false
                self.tipTextLabel.isHidden = false
                self.tipPercentLabel.isHidden = false
                self.totalView.isHidden = false
                self.splitView.isHidden = false
                self.billViewHeight.constant = self.topHeight! - 200
                self.billFieldTop.constant = 82
                self.view.layoutIfNeeded()
            })
        }
        // If billField is not empty, show other views/objects using animation
        else {
            UIView.animate(withDuration: 0.12, delay: 0, options: [.curveEaseOut], animations: {
                self.tipSlider.isHidden = true
                self.tipTextLabel.isHidden = true
                self.tipPercentLabel.isHidden = true
                self.totalView.isHidden = true
                self.splitView.isHidden = true
                self.billViewHeight.constant = self.fullHeight!
                self.billFieldTop.constant = self.topHeight! - 100 - 16
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        // Get bill and tip percentage from defaults
        let bill = defaults.double(forKey: "bill")
        let tipValue = defaults.double(forKey: "tipPercentage")
        // Calculate tip and total values
        let tip = bill * tipValue
        let total = bill + tip
        
        // Update text of labels
        /*
        tipValueLabel.text = String(format: "%@%.2f", currencySymbol!, tip)
        totalLabel.text = String(format: "%@%.2f", currencySymbol!, total)
        split2Label.text = String(format: "%@%.2f", currencySymbol!, total/2)
        split3Label.text = String(format: "%@%.2f", currencySymbol!, total/3)
        split4Label.text = String(format: "%@%.2f", currencySymbol!, total/4)
        split5Label.text = String(format: "%@%.2f", currencySymbol!, total/5)
        */
        tipValueLabel.text = formatter.string(from: NSNumber(value: tip))
        totalLabel.text = formatter.string(from: NSNumber(value: total))
        split2Label.text = formatter.string(from: NSNumber(value: total/2))
        split3Label.text = formatter.string(from: NSNumber(value: total/3))
        split4Label.text = formatter.string(from: NSNumber(value: total/4))
        split5Label.text = formatter.string(from: NSNumber(value: total/5))
        formatter.string(from: NSNumber(value: defaults.double(forKey: "bill")))
    }
}

