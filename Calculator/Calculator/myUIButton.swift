//
//  myUIButton.swift
//  Calculator
//
//  Created by 严思远 on 2021/10/10.
//

import UIKit

class myUIButton: UIButton {

    let orient = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        switch orient {
        case .portrait:
            self.layer.cornerRadius = 45
            break
        default:
            self.layer.cornerRadius = 23
            break
        }
    }

}
