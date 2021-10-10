//
//  ViewController.swift
//  Calculator
//
//  Created by 严思远 on 2021/9/14.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet var buttonsCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.displayLabel.text = "0"
        
        
        //感知设备方向 - 开启监听设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //添加通知，监听设备方向改变
        NotificationCenter.default.addObserver(self, selector: #selector(receivedRotation), name: UIDevice.orientationDidChangeNotification, object: nil)

        //关闭设备监听
        //UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    }
    
    //通知监听触发的方法
    @objc func receivedRotation(_ notification: Notification){
        let device = UIDevice.current
        switch device.orientation{
        case .portrait:
            changeCornerRadius(45)
            break;
        case .landscapeLeft:
            changeCornerRadius(23)
            break;
        case .landscapeRight:
            changeCornerRadius(23)
            break;
        default:
            break;
        }
    }
    
    func changeCornerRadius(_ radius:Double){

        for i in 1...49{
            if let tempButton = self.view.viewWithTag(i) as? UIButton{
                buttonsCollection.append(tempButton)
            }
        }
        
        for button in buttonsCollection{
            button.layer.cornerRadius = CGFloat(radius)
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
    
    let calculator = Calculator()
    @IBAction func operatorTouched(_ sender:UIButton){
        if let op = sender.currentTitle {
            if let result = calculator.performOperation(operation: op, operand: Double(digitOnDisplay)!){
                digitOnDisplay = String(result)
            }
            
            inTypingMode = false
        }
    }
    
}

