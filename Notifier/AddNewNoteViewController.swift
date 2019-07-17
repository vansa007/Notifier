//
//  AddNewNoteViewController.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import UIKit

protocol AddNewNoteDelegate: class {
    func didInsertedNote()
}

class AddNewNoteViewController: UIViewController {
    
    @IBOutlet weak var titleTF: RoundTextField!
    @IBOutlet weak var contentTV: UITextView!
    
    weak var delegate: AddNewNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneToKeyboard()
    }
    
    private func addDoneToKeyboard() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))]
        numberToolbar.sizeToFit()
        titleTF.inputAccessoryView = numberToolbar
        contentTV.inputAccessoryView = numberToolbar
    }
    
    @objc func doneAction() {
        titleTF.resignFirstResponder()
        contentTV.resignFirstResponder()
    }
    
    private func todayDateString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    @IBAction func closeAction(_ sender: UIButton) {
        doneAction()
        guard let titleSt = titleTF.text else { return }
        guard let contentSt = contentTV.text else { return }
        
        // exit
        if titleSt.isEmpty && contentSt.isEmpty {
            self.dismiss(animated: true, completion: nil)
        } else if titleSt.isEmpty {
            alertMessage(title: nil, contentMessage: "Please check title again!")
        } else if contentSt.isEmpty {
            alertMessage(title: nil, contentMessage: "Please check content again!")
        } else {
            let realmManager = DBManager.shared
            let id = realmManager.incrementID()
            let newItemNote = NoteItemModel(id: id, dateCreated: todayDateString(), titleNote: titleTF.text!, meaningNote: contentTV.text!, status: -1)
            realmManager.addData(object: newItemNote)
            self.dismiss(animated: true) {
                self.delegate?.didInsertedNote()
            }
        }
    }
}
