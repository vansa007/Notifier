//
//  StatusKnowledgeViewController.swift
//  Notifier
//
//  Created by vansa pha on 17/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import UIKit

protocol StatusKnowledgeDelegate: class {
    func didSelectedColor()
}

class StatusKnowledgeViewController: UIViewController {

    @IBOutlet weak var colorTableView: UITableView!
    @IBOutlet weak var dismissView: UIView!
    
    private let titleArr = [
        "Really don't remember this.",
        "Now it's in my temporary memory.",
        "Sure, I clear about this."
    ]
    private let colorArr = [#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1), #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)]
    
    //public
    var item: NoteItemModel!
    weak var delegate: StatusKnowledgeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDismissViewGesture()
    }
    
    private func setDismissViewGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        dismissView.addGestureRecognizer(tap)
    }
    
    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension StatusKnowledgeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "color_cell", for: indexPath) as! KnowledgeTableViewCell
        cell.titleLb.text = titleArr[indexPath.row]
        cell.colorView.backgroundColor = colorArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sts = -1
        if indexPath.row == 0 {
            sts = -1
        } else if indexPath.row == 1 {
            sts = 0
        } else if indexPath.row == 2 {
            sts = 1
        }
        let newItem = NoteItemModel(id: item.id, dateCreated: item.date_created, titleNote: item.title_note, meaningNote: item.meaning_note, status: sts)
        DBManager.shared.addData(object: newItem)
        self.dismiss(animated: true) {
            self.delegate?.didSelectedColor()
        }
    }
}
