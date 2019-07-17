//
//  NoteItemTableViewCell.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import UIKit

class NoteItemTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var meaningLb: UILabel!
    @IBOutlet weak var statusBtn: UIButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func renderCell(noteItemTBC model: NoteItemModel) {
        dateLb.text = dateMakeUp(dateString: model.date_created)
        titleLb.text = model.title_note
        meaningLb.text = model.meaning_note
        statusBtn.backgroundColor = setupKnowledgeStatus(status: model.sts)
    }
    
    private func dateMakeUp(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateVal = dateFormatter.date(from: dateString) else { return nil }
        
        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = "d MMMM yyyy"
        return newDateFormat.string(from: dateVal)
    }
    
    private func setupKnowledgeStatus(status: Int) -> UIColor {
        if status == -1 { // red: still don't remember
            return #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        } else if status == 0 { // yellow: temp in brand
            return #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)
        } else { // green: clear about it
            return #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        }
    }

}
