//
//  ViewController.swift
//  Calculator
//
//  Created by 严思远 on 2021/9/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var radLabel: UILabel!
    
    var buttonsCollection = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.displayLabel.text = "0"
        self.radLabel.text = ""
        
        initUIButtonCollection()
        
        //感知设备方向 - 开启监听设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //添加通知，监听设备方向改变
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRotation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func initUIButtonCollection(){
        for i in 1...19{
            if let tempButton = view.viewWithTag(i) as? UIButton{
                buttonsCollection.append(tempButton)
            }
        }
    }
    
    //通知监听触发的方法
    @objc func receivedRotation(_ notification: Notification){
        let device = UIDevice.current
        switch device.orientation{
        case .portrait:
            changeCornerRadius(45)
        case .landscapeLeft:
            fallthrough
        case .landscapeRight:
            changeCornerRadius(23)
        default: break
        }
    }
    
    func changeCornerRadius(_ radius:Double){
        if (radius == 23){
            for i in 1...49{
                if let tempButton = view.viewWithTag(i) as? UIButton{
                    if(i > 19){
                        buttonsCollection.append(tempButton)
                    }
                    buttonsCollection[i-1].layer.cornerRadius = CGFloat(radius)
                }
            }
        }else{
            for i in 1...19{
                buttonsCollection[i-1].layer.cornerRadius = CGFloat(radius)
            }
        }
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
    
    var second: Bool = false
    
    let calculator = Calculator()
    @IBAction func operatorTouched(_ sender:UIButton){
        if let op = sender.currentTitle {
            
            if op == "Rad" {
                buttonsCollection[43].setTitle("Deg", for: .normal)
                self.radLabel.text = "Rad"
            }else if op == "Deg" {
                buttonsCollection[43].setTitle("Rad", for: .normal)
                self.radLabel.text = ""
            }
            
            if op == "2ⁿᵈ" {
                if second {
                    buttonsCollection[29].setTitle("eˣ", for: .normal)
                    buttonsCollection[30].setTitle("10ˣ", for: .normal)
                    buttonsCollection[35].setTitle("ln", for: .normal)
                    buttonsCollection[36].setTitle("log₁₀", for: .normal)
                    buttonsCollection[38].setTitle("sin", for: .normal)
                    buttonsCollection[39].setTitle("cos", for: .normal)
                    buttonsCollection[40].setTitle("tan", for: .normal)
                    buttonsCollection[44].setTitle("sinh", for: .normal)
                    buttonsCollection[45].setTitle("cosh", for: .normal)
                    buttonsCollection[46].setTitle("tanh", for: .normal)
                }else{
                    buttonsCollection[29].setTitle("yˣ", for: .normal)
                    buttonsCollection[30].setTitle("2ˣ", for: .normal)
                    buttonsCollection[35].setTitle("logᵧ", for: .normal)
                    buttonsCollection[36].setTitle("log₂", for: .normal)
                    buttonsCollection[38].setTitle("sin⁻¹", for: .normal)
                    buttonsCollection[39].setTitle("cos⁻¹", for: .normal)
                    buttonsCollection[40].setTitle("tan⁻¹", for: .normal)
                    buttonsCollection[44].setTitle("sinh⁻¹", for: .normal)
                    buttonsCollection[45].setTitle("cosh⁻¹", for: .normal)
                    buttonsCollection[46].setTitle("tanh⁻¹", for: .normal)
                }
                second = !second
            }
            
            if let tempResult = calculator.performOperation(operation: op, operand: Double(digitOnDisplay)!){
                
                let floatResult = Float((tempResult * 10000000).rounded()) / 10000000
                var result = ""
                
                if floatResult.truncatingRemainder(dividingBy: 1) == 0{
                    result += String(Int(floatResult))
                }else{
                    result += String(floatResult)
                }
                
                digitOnDisplay = result
            }
            
            inTypingMode = false
        }
    }
    
}
