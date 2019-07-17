//
//  Extension.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import Foundation

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension UIViewController {
    func alertMessage(title: String?, contentMessage: String, confirmBtnTitle: String = "확인") {
        let alert = UIAlertController(title: title, message: contentMessage, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: confirmBtnTitle, style: .cancel, handler: nil)
        alert.addAction(confirmBtn)
        present(alert, animated: true)
    }
    
    func alertMessage(title: String?, contentMessage: String, confirmBtnTitle: String = "확인", action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: contentMessage, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: confirmBtnTitle, style: .cancel, handler: action)
        alert.addAction(confirmBtn)
        present(alert, animated: true)
    }
    
    func alertMessage(title: String?, contentMessage: String, confirmBtnTitle: String = "확인", cancelBtnTitle: String = "취소", action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: contentMessage, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: confirmBtnTitle, style: .default, handler: action)
        let cancelBtn = UIAlertAction(title: cancelBtnTitle, style: .cancel, handler: action)
        alert.addAction(confirmBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
    }
}
