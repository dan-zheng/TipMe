//
//  SettingsViewController.swift
//  tipme
//
//  Created by Dan Zheng on 12/18/16.
//  Copyright © 2016 Dan Zheng. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipPercentLabel: UILabel!
    
    // Use defaults to save application data
    let defaults = UserDefaults.standard
    
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Allow portrait orientation only.
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBAction func onTipChange(_ sender: AnyObject) {
        // Calculate tip percentage and store in defaults
        let tipPercent = Float(round(tipSlider.value * 100))
        defaults.set(tipPercent/100, forKey: "tipPercentage")
        defaults.synchronize()
        
        // Update tipPercentLabel text
        tipPercentLabel.text = String(format: "%.f%%", tipPercent)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
