//
//  RoundTextField.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import UIKit

class RoundTextField: UITextField {
    
    private let paddingLeftRight: CGFloat = 10.0

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: paddingLeftRight, bottom: 0, right: paddingLeftRight)
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: paddingLeftRight, bottom: 0, right: paddingLeftRight)
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: paddingLeftRight, bottom: 0, right: paddingLeftRight)
        return bounds.inset(by: padding)
    }

}
