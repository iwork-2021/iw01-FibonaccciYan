//
//  ViewController.swift
//  Calculator
//
//  Created by 严思远 on 2021/9/14.
//

import UIKit

class PortraitViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.displayLabel.text = "0"
    }
    
    var digitOnDisplay:String{
        get{
            return self.displayLabel.text!
        }
        set{
            self.displayLabel.text! = newValue
        }
    }
    
    var inTypingMode = false

    @IBAction func numberTouched(_ sender:UIButton){
        if inTypingMode{
            digitOnDisplay = digitOnDisplay + sender.currentTitle!
        }else{
            digitOnDisplay = sender.currentTitle!
            inTypingMode = true
        }
    }
    
    let calculator = Calculator()
    @IBAction func operatorTouched(_ sender:UIButton){
        if let op = sender.currentTitle {
            if let result = calculator.performOperation(operation: op, operand: Double(digitOnDisplay)!){
                digitOnDisplay = String(result)
            }
            
            inTypingMode = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.blockRotation = true
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate.blockRotation = false
        
        //判断退出时是否是横屏
        if UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape != nil {
            //是横屏让变回竖屏
            setNewOrientation(fullScreen: false)
        }
        
    }
    
    //横竖屏
    func setNewOrientation(fullScreen: Bool) {
        if fullScreen { //横屏
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")
            
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.landscapeLeft.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
            
        }else { //竖屏
            let resetOrientationTargert = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
            UIDevice.current.setValue(resetOrientationTargert, forKey: "orientation")
            
            let orientationTarget = NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }
    }
}

