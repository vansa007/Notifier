//
//  DetailNoteViewController.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import UIKit

class DetailNoteViewController: UIViewController {
    
    // connection outlet
    @IBOutlet weak var titleNoteLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var contentLb: UITextView!
    
    //public
    var itemData: NoteItemModel!
    var isHiddenContent: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        renderInformation()
        addDoneToKeyboard()
    }
    
    private func renderInformation() {
        titleNoteLb.text = itemData.title_note
        contentLb.text = itemData.meaning_note
        contentLb.isHidden = isHiddenContent
        dateLb.text = dateMakeUp(dateString: itemData.date_created)
    }
    
    private func addDoneToKeyboard() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))]
        numberToolbar.sizeToFit()
        contentLb.inputAccessoryView = numberToolbar
    }
    
    @objc func doneAction() {
        contentLb.resignFirstResponder()
    }
    
    private func dateMakeUp(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateVal = dateFormatter.date(from: dateString) else { return nil }
        
        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = "d MMMM yyyy"
        return newDateFormat.string(from: dateVal)
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        sender.isHidden = true
        contentLb.isEditable = true
        contentLb.isSelectable = true
        contentLb.becomeFirstResponder()
    }
    
    @IBAction func showContentAction(_ sender: UIButton) {
        isHiddenContent.toggle()
        contentLb.isHidden.toggle()
    }
}
